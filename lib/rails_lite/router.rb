class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    method = req.params['_method'] || req.request_method
    method == http_method.to_s.upcase && req.path =~ pattern
  end

  def run(req, res)
    # use pattern to pull out route params
    match_route = pattern.match(req.path)
    route_params = {}.tap do |params|
      match_route.names.each {|name| params[name] = match_route[name]}
    end
    # init controller and call action
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  def draw(&proc)
    instance_eval(&proc)
  end

  # make each of these methods that
  # when called adds a route
  [:get, :post, :put, :delete].each do |http_method|
    define_method http_method do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.find {|route| route.matches?(req)}
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = 404
      res['Content-Type'] = "text/plain"
      res.write("404 Nothing to see here...")
    end
  end
end
