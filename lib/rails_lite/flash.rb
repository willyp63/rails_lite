require 'json'

class Flash
  COOKIE_NAME = '_rails_lite_app_flash'

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

  def store_flash(res)
    res.set_cookie(COOKIE_NAME, path: '/', value: @curr_cookie.to_json)
  end
end
