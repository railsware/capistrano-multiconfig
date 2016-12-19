require 'capistrano/multiconfig/dsl'

include Capistrano::DSL
include Capistrano::Multiconfig::DSL

namespace :load do
  task :defaults do
    load 'capistrano/defaults.rb'
  end
end

if Gem::Version.new(Capistrano::VERSION) >= Gem::Version.new('3.5.0')
  require "airbrussh/capistrano"

  Airbrussh.configure do |airbrussh|
    airbrussh.banner = false
    airbrussh.command_output = true
  end
end

stages.each do |stage|
  Rake::Task.define_task(stage) do

    # Set stage variable
    set(:stage, stage)

    # Load defaults variables
    invoke 'load:defaults'

    # Load stage configuration(s).
    #
    # For stage 'production' will be loaded next configurations:
    #
    # * config/deploy.rb
    # * config/deploy/production.rb
    #
    # For stage 'soa:blog:production' will be loaded next configurations:
    #
    # * config/deploy.rb
    # * config/deploy/soa.rb
    # * config/deploy/soa/blog.rb
    # * config/deploy/soa/blog/production.rb
    stage.split(':').inject([stages_root]) do |paths, segment|
      paths << File.join(paths.last, segment)
    end.each do |path|
      file = "#{path}.rb"
      load(file) if File.exists?(file)
    end

    # Set locale
    I18n.locale = fetch(:locale, :en)

    # configure core backend
    configure_backend

  end.add_description("Load #{stage} configuration")
end
