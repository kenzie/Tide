# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "tide"
  gem.homepage = "http://github.com/kenzie/tide"
  gem.license = "MIT"
  gem.summary = %Q{Tide class fetches and returns Canadian tide prediction data from waterlevels.gc.ca}
  gem.description = %Q{Tide class fetches and returns Canadian tide prediction data from waterlevels.gc.ca. Accepts options for tide zone, tide region, tide station, date and timezone. Defaults to 7 days of tide prediction data (starting from today) for Sydney, Nova Scotia in Atlantic time. Outputs a semi-colon delimited array of tides (date, time, height in meters) with Tide.new.to_csv or a formatted html table with Tide.new.to_html.}
  gem.email = "kenzie@route19.com"
  gem.authors = ["Kenzie Campbell"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tide #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
