# coding: utf-8

unless defined?(Motion::Project::Config)
  raise "This gem works only within a RubyMotion android project."
end

lib_dir_path = File.dirname(File.expands_path(__FILE__))

Motion::Project::App.setup do |app|
  app.files.unshift(Dir.glob(File.join(lib_dir_path, "android_query/**/*.rb")))
end
