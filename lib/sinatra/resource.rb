require 'sinatra/base'
require 'active_support'

module Sinatra
  module Resource
    def resource(model, options = {}, &block)
      setup_routes(model, options)
    end
    
    protected
      def setup_routes(model, options)
        get '/test' do
          "TEST"
        end
      end
  end

end