require 'sinatra/base'
require 'active_support/inflector'

module Sinatra
  module Resource
    DEFAULT_FORMAT = :json

    def get_with_formats(path, options = {}, &block)
      route_method_for_formats :get, path, options, &block
    end

    def post_with_formats(path, options = {}, &block)
      route_method_for_formats :post, path, options, &block
    end

    def put_with_formats(path, options = {}, &block)
      route_method_for_formats :put, path, options, &block
    end

    def delete_with_formats(path, options = {}, &block)
      route_method_for_formats :delete, path, options, &block
    end

    def resource(model, options = {}, &block)
      klass = Class.new

      klass.class_eval <<-"end_eval", __FILE__, __LINE__
        attr_accessor :request, :params, :wants

        def self.controller_name
          "#{model.to_s.demodulize.downcase.pluralize}"
        end

        def self.model_name
          "#{model.to_s.demodulize.downcase}"
        end
        
        def self.model
          model
        end

        def respond_to
          yield wants
        end

        include ResourceMapper::Controller
      end_eval
      setup_routes(model, klass.new)
    end

    private
      def route_method_for_formats(method, path, options = {}, &block)
        self.method(method).call "#{path}.:format", options, &method_with_format_handler(&block)
        self.method(method).call "#{path}", options, &method_with_format_handler(&block)
      end

      def method_with_format_handler(&block)
        lambda do
          wants = {}
          format = (params[:format] || DEFAULT_FORMAT).to_sym
          def wants.method_missing(type, *args, &handler)
            self[type] = handler
          end

          block.bind(self).call(wants)
          halt 404 if wants[format].nil?

          wants[format].call
        end
      end
    
      def route_handler(resource, method)
        lambda do |wants|
          resource.params = params
          resource.request = request
          resource.wants = wants
          resource.method(method).call
        end
      end
    
      def setup_routes(model, resource)
        name = model.to_s.demodulize.downcase

        get_with_formats    "/#{name.pluralize}", {}, &route_handler(resource, :index)
        get_with_formats    "/#{name}/:id",       {}, &route_handler(resource, :show)
        post_with_formats   "/#{name}",           {}, &route_handler(resource, :create)
        put_with_formats    "/#{name}/:id",       {}, &route_handler(resource, :update)
        delete_with_formats "/#{name}/:id",       {}, &route_handler(resource, :destroy)
      end
  end
end