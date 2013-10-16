module Capistrano
  module Multiconfig
    class Configurations
      def self.find_names(root_path)
        new(root_path).find_names
      end

      attr_reader :root_path

      def initialize(root_path)
        @root_path = root_path
      end

      # find configuration names
      def find_names
        files = scan_files
        files.sort!
        remove_shared_files!(files)
        build_names(files)
      end

      private

      # Scan recursively root path
      def scan_files
        Dir["#{root_path}/**/*.rb"]
      end

      # Remove path when there is the same directory with child.
      #
      # app/staging.rb (is shared configuration for 'alpha' and 'beta')
      # app/staging/alpha.rb
      # app/staging/beta.rb
      def remove_shared_files!(files)
        files.reject! do |file|
          dir = file.gsub(/\.rb$/, '/')
          files.any? { |f| f[0, dir.size] == dir }
        end
      end

      # Convert "app/blog/production" to "app:blog:production"
      def build_names(files)
        files.map do |file|
          file.sub("#{root_path}/", '').sub(/\.rb$/, '').gsub('/', ':')
        end
      end
    end
  end
end
