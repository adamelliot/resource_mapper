require 'rubygems'
require 'micronaut'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'resource_mapper'
require 'rack/test'
require 'json'

require File.expand_path(File.dirname(__FILE__)) + '/models'

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |c|
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true

  c.include Rack::Test::Methods

  def app ; Rack::Lint.new(@app) end

  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end
end
