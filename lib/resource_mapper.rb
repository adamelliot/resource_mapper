require 'sinatra/base'
require 'active_support'
require 'mongo_mapper'

module ResourceMapper
  ACTIONS           = [:index, :show, :create, :update, :destroy]
  SINGLETON_ACTIONS = (ACTIONS - [:index]).freeze
  FAILABLE_ACTIONS  = (ACTIONS - [:index]).freeze
  NAME_ACCESSORS    = [:model_name, :route_name, :object_name]
end

require 'sinatra/resource'
