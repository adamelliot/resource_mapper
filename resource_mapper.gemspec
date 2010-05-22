# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{resource_mapper}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Elliot"]
  s.date = %q{2010-05-22}
  s.description = %q{Creates a resource for a model in sinatra}
  s.email = %q{adam@adamelliot.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".autotest",
     ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/example_helper.rb",
     "examples/resource_mapper_example.rb",
     "lib/resource_mapper.rb",
     "lib/resource_mapper/accessors.rb",
     "lib/resource_mapper/action_options.rb",
     "lib/resource_mapper/actions.rb",
     "lib/resource_mapper/class_methods.rb",
     "lib/resource_mapper/controller.rb",
     "lib/resource_mapper/failable_options.rb",
     "lib/resource_mapper/helpers/current_objects.rb",
     "lib/resource_mapper/helpers/internal.rb",
     "lib/resource_mapper/helpers/nested.rb",
     "lib/resource_mapper/response_collector.rb",
     "lib/sinatra/resource.rb",
     "resource_mapper.gemspec"
  ]
  s.homepage = %q{http://github.com/adamelliot/resource_mapper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Creates a resource for a model in sinatra}
  s.test_files = [
    "examples/example_helper.rb",
     "examples/resource_mapper_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<spicycode-micronaut>, [">= 0"])
    else
      s.add_dependency(%q<spicycode-micronaut>, [">= 0"])
    end
  else
    s.add_dependency(%q<spicycode-micronaut>, [">= 0"])
  end
end
