require_relative "../models/user"
require_relative "application_controller"

class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.new(name: params["user"]["name"])
    @user.save
    session["session_token"] = @user.session_token
    redirect_to "/dogs"
  end
end
