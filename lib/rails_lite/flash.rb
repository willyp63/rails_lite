require 'json'

class Flash
  # project folder name + 'flash'
  COOKIE_NAME = "_" + Dir.pwd.scan(/\/([^\/]*)/).last[0].underscore + "_flash"

  def initialize(req)
    if req.cookies[COOKIE_NAME]
      @prev_cookie = JSON.parse(req.cookies[COOKIE_NAME])
    else
      @prev_cookie = {}
    end
    @curr_cookie = {}
    @now = {}
  end

  def [](key)
    @prev_cookie[key] || @curr_cookie[key] || @now[key]
  end

  def []=(key, val)
    @curr_cookie[key] = val
  end

  def now
    @now
  end

  # only add curr_cookie to response
  def store_flash(res)
    res.set_cookie(COOKIE_NAME, path: '/', value: @curr_cookie.to_json)
  end
end
