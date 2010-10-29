# Shamelessly taken from sinatra-rest, adjusted for JSON
require 'active_support/json'

class Person
  attr_accessor :id
  attr_accessor :name
  attr_accessor :phone

  def initialize(*args)
    if args.size == 0
      @id = nil
      @name = nil
      @phone = nil
    elsif args.size == 3
      @id = args[0].to_i
      @name = args[1]
      @phone = args[2]
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
      @phone = hash['phone'] if hash.include?('phone')
    end
  end
  
  def to_json(options={})
    ret = {}
    puts options
    if !options[:only].nil?
      options[:only].each { |key| ret[key] = self.send(key) }
    else
      ret[:id] = self.id
      ret[:name] = self.name
      ret[:phone] = self.phone
    end

    ret.to_json
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
    Person.new(1, 'Al', '555-1234').save
    Person.new(2, 'Sol', '555-6666').save
    Person.new(3, 'Alma', '555-5555').save
  end
end


