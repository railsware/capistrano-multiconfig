# capistrano-multiconfig

[![Build Status](https://travis-ci.org/railsware/capistrano-multiconfig.png)](https://travis-ci.org/railsware/capistrano-multiconfig)

## Description

Capistrano extension that allows to use multiple configurations.

Multiconfig extension is similar to [multistage](https://github.com/capistrano/capistrano-ext) extenstion.
But it's not only about 'stage' configurations. It's about any configuration that you may need.
Extension recursively builds configuration list from configuration root directory.
Each configuration loads recursively configuration from it namespace files and own configuration file.

## Purpose

Extension was specially created to implement [Caphub](https://github.com/railsware/caphub) concept.
[Read more](http://railsware.com/blog/2011/11/18/caphub-multiple-applications-deployment-with-capistrano/).

## Usage

Install gem

    $ gem install capistrano-multiconfig


## Capistrano3

Use multiconfig v3.x.x

Replace `capistrano/setup` with `capistrano/multiconfig` in your `Capfile`:

    # set :stages_root, 'config/deploy'
    require 'capistrano/multiconfig'

Optionally you may set another path to your multistages configurations with *:stages_root*.

## Capistrano2

For legacy capistrano v2.x.x use multiconfig gem v0.0.x

Add to `Capfile`

    set :config_root, 'path/to/your/configurations'
    require 'capistrano/multiconfig'


## Example

Assume we need next configurations:

* services:billing:production
* services:billing:qa
* blog:production
* blog:staging
* dev:wiki

Choose configuration root directory for example `config/deploy`

Create configuration files:

    config/deploy/services/billing/production.rb
    config/deploy/services/billing/qa.rb
    config/deploy/blog/production.rb
    config/deploy/blog/staging.rb
    config/deploy/dev/wiki.rb

Add to `Capfile`:

    require 'capistrano/multiconfig'

Put related capistrano configuration to each file according to file meaning.

Check tasks:

    $ cap -T
    cap services:billing:production # Load services:billing:production configuration
    cap services:billing:qa         # Load services:billing:qa configuration
    cap blog:production             # Load blog:production configuration
    cap blog:staging                # Load blog:staging configuration
    cap wiki                        # Load wiki configuration
    cap invoke                      # Invoke a single command on the remote servers.
    cap shell                       # Begin an interactive Capistrano session.

Let's try to run task without specified configuration:

    $ cap shell
    triggering start callbacks for `shell'
      * executing `multiconfig:ensure'
    No configuration specified. Please specify one of:
      * wiki:production
      * wiki:staging
      * blog:production
      * blog:staging
    (e.g. `cap wiki:production shell')


So we must provide configuration as first task:

    $ cap services:billing:qa shell

## Configuration Loading

Configuration task loads not only configuration associated with it filename.
It also recursively load configurations from all namespaces.

For example task `cap apps/blog/qa.rb` loads with **order** next configuration files (if they exist):

* config/deploy/apps.rb
* config/deploy/apps/blog.rb
* config/deploy/apps/blog/qa.rb

So it's easy to put shared configuration.

## Custom stages configuration location

Specify in `Capfile`:

    set :stages_root, 'deployment'
    require 'capistrano/multiconfig'

## Testing

    $ bundle install
    $ rspec -fs spec

## License

* Copyright (c) 2013 Railsware [www.railsware.com](http://www.railsware.com)
* [MIT](www.opensource.org/licenses/MIT)

## References

* [capistrano](https://github.com/capistrano/capistrano)
* [caphub](https://github.com/railsware/caphub)

