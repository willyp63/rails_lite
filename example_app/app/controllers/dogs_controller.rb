require_relative "../models/dog"
require_relative "application_controller"

class DogsController < ApplicationController
  def index
    @dogs = Dog.all
    render :index
  end

  def show
    @dog = Dog.find(params["id"].to_i)
    @toys = @dog.toys
    render :show
  end

  def new
    render :new
  end

  def create
    @dog = Dog.new(name: params["dog"]["name"])
    @dog.save
    redirect_to "/dogs"
  end

  def destroy
    @dog = Dog.find(params["id"].to_i)
    @dog.destroy
    redirect_to "/dogs"
  end
end
