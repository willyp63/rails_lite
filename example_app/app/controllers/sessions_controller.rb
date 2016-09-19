require_relative "../models/user"
require_relative "application_controller"

class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @users = User.where(name: params["user"]["name"])
    unless @users.empty?
      @user = @users.first
      session["session_token"] = @user.reset_session_token!
      redirect_to "/dogs"
    else
      flash[:errors] = ["Sorry I don't recognize that name"]
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session["session_token"] = nil
    redirect_to "/dogs"
  end
end
