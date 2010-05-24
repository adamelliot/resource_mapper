# Shamelessly take from sinatra-rest

class Person
  attr_accessor :id
  attr_accessor :name

  def initialize(*args)
    #puts "new #{args.inspect}"
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
    #puts "save #{@id}"
    @@people << self
    self.id = @@people.size
  end

  def update_attributes(hash)
    #puts "update_attributes #{hash.inspect}"
    unless hash.empty?
      @id = hash['id'].to_i if hash.include?('id')
      @name = hash['name'] if hash.include?('name')
    end
  end

  def self.delete(id)
    #puts "delete #{id}"
    @@people.delete_if {|person| person.id == id.to_i}
  end

  @@people = []

  def self.all(criteria={})
    #puts 'all'
    return @@people
  end

  def self.find_by_id(id)
    #puts "find_by_id #{id}"
    all.find {|f| f.id == id.to_i}
  end

  def self.clear!
    @@people = []
  end

  def self.reset!
    clear!
    Person.new(1, 'one').save
    Person.new(2, 'two').save
    Person.new(3, 'three').save
  end
end


