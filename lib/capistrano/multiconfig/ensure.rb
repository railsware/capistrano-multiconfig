Capistrano::Configuration.instance(true).load do
  namespace :multiconfig do
    desc "[internal] Ensure that a configuration has been selected"
    task :ensure do
      unless exists?(:config_name)
        puts "No configuration specified. Please specify one of:"
        config_names.each { |name| puts "  * #{name}" }
        puts "(e.g. `cap #{config_names.first} #{ARGV.last}')"
        abort
      end
    end
  end

  on :start, 'multiconfig:ensure', :except => config_names
end
