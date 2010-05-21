require 'sinatra/base'
require 'mongomapper'

require 'sinatra/resource'

module ResourceMapper
  autoload :Resource,     'resource_mapper/resource'
end
