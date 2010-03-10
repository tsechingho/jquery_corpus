require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jquery_corpus"
    gem.summary = %Q{Manage jQuery and it's plugins for Rails 3 applications.}
    gem.description = %Q{This gem will collect useful and popular jqeury plugins and provide a reliable way to manage it via rails 3 generator.}
    gem.email = "tsechingho@gmail.com"
    gem.homepage = "http://github.com/tsechingho/jquery_corpus"
    gem.authors = ["Tse-Ching Ho"]
    #gem.add_dependency "rubygem", ">= 1.3.6"
    #gem.add_dependency "rails", ">= 3.0.0.beta"
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.3"
    gem.add_development_dependency "cucumber", ">= 0.6.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'
  Rspec::Core::RakeTask.new(:spec)
  Rspec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
  end
  task :spec => :check_dependencies
rescue LoadError
  task :spec do
    abort "Rspec is not available. In order to run specs, you must: [sudo] gem install Rspec"
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: [sudo] gem install cucumber"
  end
end

task :default => :spec

begin
  require 'rake/rdoctask'
  Rake::RDocTask.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "jquery_corpus #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue Exception
  puts "Rake is not available. In order to run rdoc, you must: [sudo] gem install rake"
end
