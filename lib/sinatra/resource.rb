require 'sinatra/base'
require 'active_support/inflector'

module Sinatra
  module Resource
    def resource(model, options = {}, &block)
      klass = Class.new
      klass.class_eval <<-"end_eval", __FILE__, __LINE__
        def self.controller_name
          "#{model.to_s.demodulize.downcase.pluralize}"
        end

        def self.model_name
          "#{model.to_s.demodulize.downcase}"
        end
        
        def self.model
          model
        end

        include ResourceMapper::Controller
      end_eval

      setup_routes(model, klass.new)
    end

    private
      def setup_routes(model, resource)
        name = model.to_s.demodulize.downcase

        get     "/#{name.pluralize}", {}, &resource.method(:index)
        get     "/#{name}/:id",       {}, &resource.method(:show)
        post    "/#{name}",           {}, &resource.method(:create)
        put     "/#{name}/:id",       {}, &resource.method(:update)
        delete  "/#{name}/:id",       {}, &resource.method(:destroy)
      end
  end
end