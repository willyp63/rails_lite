class User < ModelBase
  finalize!

  def initialize(params = {})
    super
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    save
    session_token
  end
end
