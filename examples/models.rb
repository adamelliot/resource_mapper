# Shamelessly taken from sinatra-rest, adjusted for JSON
require 'active_support/json'

class Person
  attr_accessor :id
  attr_accessor :name

  def initialize(*args)
    if args.size == 0
      @id = nil
      @name = nil
    elsif args.size == 2
      @id = args[0].to_i
      @name = args[1]
    else args.size == 1
      update_attributes(args[0])
    end
  end

  def save
    if Person.find(self.id)
      Person.delete(self.id)
    else
      self.id = self.id || @@people.size
    end

    @@people << self
  end

  def destroy
    Person.delete(self.id)
  end

  def update_attributes(hash)
    #puts "update_attributes #{hash.inspect}"
    unless hash.empty?
      @id = hash['id'].to_i if hash.include?('id')
      @name = hash['name'] if hash.include?('name')
    end
  end
  
  def to_json(_=nil, _=nil)
    "{\"id\":#{id.to_json},\"name\":#{name.to_json}}"
  end
  alias_method :as_json, :to_json

  def self.delete(id)
    @@people.delete_if {|person| person.id == id.to_i}
  end

  @@people = []

  def self.all(criteria={})
    @@people
  end

  def self.find(arg)
    id = arg.class == Hash ? arg[:id] : arg
    @@people.find {|f| f.id == id.to_i}
  end
  class << self
    alias_method :first, :find
  end

  def self.clear!
    @@people = []
  end

  def self.reset!
    clear!
    Person.new(1, 'Al').save
    Person.new(2, 'Sol').save
    Person.new(3, 'Alma').save
  end
end


