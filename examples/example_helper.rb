require 'rubygems'
require 'micronaut'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'resource_mapper'
require 'sinatra/base'
require 'rack/test'


require File.expand_path(File.dirname(__FILE__)) + '/models'

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |config|
  config.color_enabled = not_in_editor?
  config.filter_run :focused => true

  config.include Rack::Test::Methods
end

# json gem is borked, this will suit our needs
class Array 
  def to_json(*args)
    "[#{self.collect { |v| v.to_json }.join ','}]"
  end
end

class Fixnum
  def to_json(*args)
    self.to_s
  end
end

class String
  def to_json(*args)
    self.to_s
  end
end