include Capistrano::DSL

def stages_root
  fetch(:stages_root, 'config/deploy')
end

# Build stages with nested configurations
#
# @example simple stages
#
#   config
#   ├── deploy
#   │   ├── production.rb
#   │   └── staging.rb
#   └── deploy.rb
#
# * cap production
# * cap staging
#
# @example stages with nested configurations
#
#   config
#   ├── deploy
#   │   ├── soa
#   │   │   ├── blog
#   │   │   │   ├── production.rb
#   │   │   │   └── staging.rb
#   │   │   └── wiki
#   │   │       └── qa.rb
#   │   └── soa.rb
#   └── deploy.rb
#
# * cap soa:blog:production
# * cap soa:blog:staging
# * cap soa:wiki:qa
def stages
  Dir["#{stages_root}/**/*.rb"].map { |file|
    file.slice(stages_root.size + 1 .. -4).tr('/', ':')
  }.tap { |paths|
    paths.reject! { |path|
      paths.any? { |another| another != path && another.start_with?(path) }
    }
  }.sort
end

stages.each do |stage|
  Rake::Task.define_task(stage) do

    # Set stage variable
    set(:stage, stage)

    # Load defaults variables
    load "capistrano/defaults.rb"

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

    # Load SCM tasks
    load "capistrano/#{fetch(:scm)}.rb"

    # Set locale
    I18n.locale = fetch(:locale, :en)

    # configure core backend
    configure_backend

  end.add_description("Load #{stage} configuration")
end
