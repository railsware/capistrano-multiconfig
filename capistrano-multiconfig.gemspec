# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-multiconfig"
  s.version     = "3.0.5"
  s.authors     = ["Andriy Yanko"]
  s.email       = ["andriy.yanko@gmail.com"]
  s.homepage    = "https://github.com/railsware/capistrano-multiconfig"
  s.summary     = %q{Capistrano extension that allows to use multiple configurations}
  s.description = %q{
Multiconfig extension is similar to [multistage](https://github.com/capistrano/capistrano-ext) extenstion.
But it's not only about 'stage' configurations. It's about any configuration that you may need.
Extension recursively builds configuration list from configuration root directory.
Each configuration loads recursively configuration from namespace files and own configuration file.
  }
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano", ">=3.0.0"
end
