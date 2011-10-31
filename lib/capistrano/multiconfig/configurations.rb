Capistrano::Configuration.instance.load do
  # configurations root directory
  config_root = File.expand_path(fetch(:config_root, "config/deploy"))

  # list of configurations files
  config_files = Dir["#{config_root}/**/*.rb"]

  # remove configuration file if it's part of another configuration
  config_files.reject! do |config_file|
    config_dir = config_file.gsub(/\.rb$/, '/')
    config_files.any? { |file| file[0, config_dir.size] == config_dir }
  end

  # build configuration names list
  config_names = config_files.map do |config_file|
    config_file.sub("#{config_root}/", '').sub(/\.rb$/, '').gsub('/', ':')
  end

  # ensure that configuration segments don't override any method, task or namespace
  config_names.each do |config_name|
    config_name.split(':').each do |segment|
      if all_methods.any? { |m| m == segment }
        raise ArgumentError,
          "Config task #{config_name} name overrides #{segment.inspect} (method|task|namespace)"
      end
    end
  end

  # create configuration task for each configuration name
  config_names.each do |config_name|
    segments = config_name.split(':')
    namespace_names = segments[0, segments.size - 1]
    task_name = segments.last

    # create configuration task block
    block = lambda do
      desc "Load #{config_name} configuration"
      task(task_name) do
        # set configuration name as :config_name variable
        self.set(:config_name, config_name)

        # recursively load configurations
        segments.size.times do |i|
          path = ([config_root] + segments[0..i]).join('/') + '.rb'
          self.load(path) if File.exists?(path)
        end
      end
    end

    # wrap task block into namespace blocks
    block = namespace_names.reverse.inject(block) do |child, name|
      lambda do
        namespace(name, &child)
      end
    end

    # create configuration task
    block.call
  end

  # set configuration names list
  set(:config_names, config_names)
end
