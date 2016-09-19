class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    # allow forms to overwrite POST with '_method'
    method = req.params['_method'] || req.request_method
    method.upcase == http_method.to_s.upcase && req.path =~ pattern
  end

  def run(req, res)
    params = route_params(pattern, req)
    controller_class.new(req, res, params).invoke_action(action_name)
  end

  private
  def route_params(pattern, req)
    match_route = pattern.match(req.path)
    {}.tap do |params|
      match_route.names.each {|name| params[name] = match_route[name]}
    end
  end
end

class Router
  attr_reader :routes

  RESOURCES = [:index, :show, :new, :create, :edit, :update, :destroy];
  RESOURCE_METHODS = {
    index: :get,
    show: :get,
    new: :get,
    create: :post,
    edit: :get,
    update: :patch,
    destroy: :delete
  }
  RESOURCE_PATTERNS = {
    index: "^/x$",
    show: "^/x/(?<id>\\d+)$",
    new: "^/x/new$",
    create: "^/x$",
    edit: "^/x/(?<id>\\d+)/edit$",
    update: "^/x/(?<id>\\d+)$",
    destroy: "^/x/(?<id>\\d+)$"
  }

  def initialize
    @routes = []
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    elsif req.path == "/"
      # redirect to root
      res.status = 302
      res['Location'] = @root_url
    else
      # display page not found
      res.status = 404
      res['Content-Type'] = "text/plain"
      res.write("404 Nothing to see here!")
    end
  end

  def root(url)
    @root_url = url
  end

  # basic methods for adding routes
  [:get, :post, :put, :delete].each do |http_method|
    define_method http_method do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # adds multiple routes for a collection
  def resources(name, options = {}, &prc)
    resources_from_options(options).each do |rsc|
      pattern = RESOURCE_PATTERNS[rsc].sub("x", name.to_s)
      controller_class = (name.to_s.capitalize + "Controller").constantize
      add_route(Regexp.new(pattern), RESOURCE_METHODS[rsc], controller_class, rsc)
    end
  end

  # adds multiple routes for a member
  def resource(name, options = {}, &prc)
    resources_from_options(options).each do |rsc|
      pattern = RESOURCE_PATTERNS[rsc].sub("x", name.to_s).sub("/(?<id>\\d+)", "")
      controller_class = (name.to_s.pluralize.capitalize + "Controller").constantize
      add_route(Regexp.new(pattern), RESOURCE_METHODS[rsc], controller_class, rsc)
    end
  end

  def member(name)
    # TODO
  end

  def collection(name)
    # TODO
  end

  private
  def resources_from_options(options)
    defaults = {only: RESOURCES, except: []}
    options = defaults.merge(options);

    unless options.values.all? {|rscs| rscs.all? {|rsc| RESOURCES.include?(rsc)}}
      raise "invalid resource name in resources/resource method on router"
    end

    options[:only] - options[:except]
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def match(req)
    @routes.find {|route| route.matches?(req)}
  end
end
