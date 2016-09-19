require_relative "../models/toy"
require_relative "application_controller"

class ToysController < ApplicationController
  def create
    @toy = Toy.new(name: params["toy"]["name"], dog_id: params["toy"]["dog_id"])
    @toy.save
    redirect_to "/dogs/#{params['dog_id']}"
  end

  def destroy
    @toy = Toy.find(params["id"].to_i)
    @toy.destroy
    redirect_to "/dogs/#{@toy.dog_id}"
  end
end
