require 'capistrano/multiconfig/configurations'

include Capistrano::DSL

config_root_path = File.expand_path(fetch(:config_root, "config/deploy"))

config_names = Capistrano::Multiconfig::Configurations.find_names(config_root_path)

config_names.each do |config_name|
  Rake::Task.define_task(config_name) do
    set(:config_name, config_name)
    segments = config_name.split(":")
    segments.size.times do |i|
      path = File.join([config_root_path] + segments[0..i]) + '.rb'
      load(path) if File.exists?(path)
    end
  end.add_description("Load #{config_name} configuration")
end

set(:config_names, config_names)

def stages
  fetch(:config_names)
end
