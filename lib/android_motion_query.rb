# coding: utf-8
require 'rubygems'
require 'motion-gradle'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), "android_motion_query/**/*.rb")).each do |file|
    app.files.unshift(file)
  end
  app.api_version = '21'
  # app.permissions << :internet
  app.gradle do
    dependency 'com.android.volley:volley:1.0.+'
  end
end
