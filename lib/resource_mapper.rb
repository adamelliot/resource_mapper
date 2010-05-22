require 'sinatra/base'
require 'active_support'
require 'mongo_mapper'

module ResourceMapper
  ACTIONS           = [:index, :show, :create, :update, :destroy]
  SINGLETON_ACTIONS = (ACTIONS - [:index]).freeze
  FAILABLE_ACTIONS  = (ACTIONS - [:index]).freeze
  NAME_ACCESSORS    = [:model_name, :route_name, :object_name]
  
  autoload :Accessors,              'resource_mapper/accessors'
  autoload :ActionOptions,          'resource_mapper/action_options'
  autoload :Actions,                'resource_mapper/actions'
  autoload :ClassMethods,           'resource_mapper/class_methods'
  autoload :Controller,             'resource_mapper/controller'
  autoload :FailableActionOptions,  'resource_mapper/failable_action_options'
  autoload :ResponseCollector,      'resource_mapper/response_collector'

  module Helpers
    autoload :Internal,       'resource_mapper/controller/internal'
    autoload :Nested,         'resource_mapper/controller/nested'
    autoload :CurrentObjects, 'resource_mapper/controller/current_objects'

    include ResourceMapper::Helpers::Internal
    include ResourceMapper::Helpers::Nested
    include ResourceMapper::Helpers::CurrentObjects
  end

end

require 'sinatra/resource'
