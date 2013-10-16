require 'capistrano/multiconfig/configurations'

include Capistrano::DSL

config_root_path = File.expand_path(fetch(:config_root, "config/deploy"))

config_names = Capistrano::Multiconfig::Configurations.find_names(config_root_path)

config_names.each do |config_name|
  Rake::Task.define_task(config_name) do
    set(:config_name, config_name)

    load "capistrano/defaults.rb"

    paths = [ config_root_path + '.rb' ]

    (segments = config_name.split(":")).size.times do |i|
      paths << File.join([config_root_path] + segments[0..i]) + '.rb'
    end

    paths.each { |path| load(path) if File.exists?(path) }

    load "capistrano/#{fetch(:scm)}.rb"
    I18n.locale = fetch(:locale, :en)
    configure_backend
  end.add_description("Load #{config_name} configuration")
end

set(:config_names, config_names)

def stages
  fetch(:config_names)
end
