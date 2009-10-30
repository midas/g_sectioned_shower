require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "g_sectioned_shower"
    gem.summary = %Q{A Guilded (http://github.com/midas/guilded/tree/master) component that creates adaptable show (detail) views of a single ActiveRecord object.}
    gem.description = %Q{A Guilded (http://github.com/midas/guilded/tree/master) component that creates adaptable show (detail) views of a single ActiveRecord object.}
    gem.email = "jason@lookforwardenterprises.com"
    gem.homepage = "http://github.com/midas/tester"
    gem.authors = ["C. Jason Harrelson (midas)"]
    gem.add_dependency 'rails', ">= 2.2.0"
    gem.add_dependency 'guilded', ">= 1.0.0"
    gem.add_development_dependency "shoulda"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tester #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
