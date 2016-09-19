class ApplicationController < ControllerBase
  def current_user
    users = User.where(session_token: session["session_token"])
    users.empty? ? nil : users.first
  end
end
