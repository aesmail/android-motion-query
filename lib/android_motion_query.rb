# coding: utf-8

require 'rubygems'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), "android_motion_query/**/*.rb")).each do |file|
    app.files.unshift(file)
    app.api_version = '21'
  end
end
