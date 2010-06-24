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
        attr_accessor :app, :wants
        delegate :request, :response, :params, :session, :to => :app

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
      klass.class_eval &block if block_given?
      setup_routes(model, klass)
    end

    private
      def route_method_for_formats(method, path, options = {}, &block)
        handler = method_with_format_handler(&block)
        self.method(method).call "#{path}.:format", options, &handler
        self.method(method).call "#{path}", options, &handler
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
    
      def route_handler(resource_klass, method)
        lambda do |wants|
          resource = resource_klass.new
          resource.app = self
          resource.wants = wants
          resource.method(method).call
        end
      end
    
      def setup_routes(model, resource)
        name = model.to_s.demodulize.downcase

        get_with_formats    "/#{name.pluralize}", {}, &route_handler(resource, :index)    unless resource.instance_methods.index(:index).nil?
        get_with_formats    "/#{name}/:id",       {}, &route_handler(resource, :show)     unless resource.instance_methods.index(:show).nil?
        post_with_formats   "/#{name}",           {}, &route_handler(resource, :create)   unless resource.instance_methods.index(:create).nil?
        put_with_formats    "/#{name}/:id",       {}, &route_handler(resource, :update)   unless resource.instance_methods.index(:update).nil?
        delete_with_formats "/#{name}/:id",       {}, &route_handler(resource, :destroy)  unless resource.instance_methods.index(:destroy).nil?
      end
  end

  class Base
    class << self
      alias_method :orig_helpers, :helpers
      def helpers(*extensions, &block)
        ResourceMapper::Helpers.class_eval(&block) if block_given?
        orig_helpers *extensions, &block
      end
    end
  end
end