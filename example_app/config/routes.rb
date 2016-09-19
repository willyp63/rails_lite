require_relative "../app/controllers/dogs_controller"
require_relative "../app/controllers/toys_controller"
require_relative "../app/controllers/sessions_controller"
require_relative "../app/controllers/users_controller"

require 'byebug'

RailsLite.router.draw do
  root "/dogs"

  resources :dogs, except: [:edit, :update]

  post Regexp.new("^/dogs/(?<dog_id>\\d+)/toys$"), ToysController, :create
  delete Regexp.new("^/toys/(?<id>\\d+)$"), ToysController, :destroy

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
end
