# Shamelessly take from sinatra-rest, adjusted for JSON

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
#    puts Person.all.inspect
    if Person.find(self.id)
#      puts "Deleting #{self.name}"
      Person.delete(self.id)
    else
#      puts "Auto id: #{self.id}, #{@@people.size}"
      self.id = self.id || @@people.size
    end
#    puts "save - New person"
    
    @@people << self
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

  def self.delete(id)
    #puts "delete #{id}"
    @@people.delete_if {|person| person.id == id.to_i}
  end

  @@people = []

  def self.all(criteria={})
    #puts 'all'
    @@people
  end

  def self.find(id)
    #puts "find #{id}"
    @@people.find {|f| f.id == id.to_i}
  end

  def self.clear!
    @@people = []
  end

  def self.reset!
#    puts "=> reset"

    clear!
    Person.new(1, 'Al').save
    Person.new(2, 'Sol').save
    Person.new(3, 'Alma').save
  end
end


