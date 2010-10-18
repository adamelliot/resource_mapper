require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "resource_mapper"
    gem.summary = %Q{A resource_controller derivate that brings similar functionality to Sinatra, but provides a simple way to create restful APIs}
    gem.description = %Q{Creates a resource for a model in sinatra}
    gem.email = "adam@adamelliot.com"
    gem.homepage = "http://github.com/adamelliot/resource_mapper"
    gem.authors = ["Adam Elliot"]
    gem.add_dependency "sinatra", ">= 1.0"
    gem.add_dependency "plist", ">= 3.1.0"
    gem.add_dependency "builder", ">= 2.1.2"
    gem.add_dependency "activesupport", ">= 3.0.0"
    gem.add_dependency "mongo_mapper", ">= 0.8.4"
    gem.add_development_dependency "micronaut", ">= 0.3.0"
    gem.add_development_dependency "rack-test", ">= 0.5.5"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'micronaut/rake_task'
  Micronaut::RakeTask.new(:examples) do |examples|
    examples.pattern = 'examples/**/*_example.rb'
    examples.ruby_opts << '-Ilib -Iexamples -rexample_helper.rb'
  end

  Micronaut::RakeTask.new(:rcov) do |examples|
    examples.pattern = 'examples/**/*_example.rb'
    examples.rcov_opts = %[--exclude "examples/*,gems/*,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
    examples.rcov = true
  end
rescue
  task :examples do
    abort "Micronaut is not available. In order to run reek, you must: sudo gem install micronaut"
  end

  task :rcov do
    abort "Micronaut is not available. In order to run reek, you must: sudo gem install micronaut"
  end
end

task :examples => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :examples

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "resource_mapper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
