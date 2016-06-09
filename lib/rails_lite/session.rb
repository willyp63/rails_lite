require 'json'

class Session
  COOKIE_NAME = "_" + Dir.pwd.scan(/\/([^\/]*)/).last[0].underscore

  # find the cookie for this app
  # deserialize the cookie into a hash
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

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(COOKIE_NAME, path: '/', value: @cookie.to_json)
  end
end
