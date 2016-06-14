require 'json'

class Session
  # project folder name
  COOKIE_NAME = "_" + Dir.pwd.scan(/\/([^\/]*)/).last[0].underscore

  def initialize(req)
    if req.cookies[COOKIE_NAME]
      @cookie = JSON.parse(req.cookies[COOKIE_NAME])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    res.set_cookie(COOKIE_NAME, path: '/', value: @cookie.to_json)
  end
end
