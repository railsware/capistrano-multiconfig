# capistrano-multiconfig

## Description

Capistrano extension that allows to use multiple configurations.

Multiconfig extension is similar to [multistage](https://github.com/capistrano/capistrano-ext) extenstion.
But it's not only about 'stage' configurations. It's about any configuration that you may need.
Extension recursively builds configuration list from configuration root directory.
Each configuration loads recursively configuration from it namespace files and own configuration file.

## Usage

Install gem

    $ gem install capistrano-multistage


Add to `Capfile`

    set :config, 'path/to/your/configurations'
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

    set :config_root, 'config/deploy'
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

For example for *:config_root* `config/deploy` task `cap apps/blog/qa.rb` loads with **order** next configuration files (if they exist):

* config/deploy/apps.rb
* config/deploy/apps/blog.rb
* config/deploy/apps/blog/qa.rb

So it's easy to put shared configuration.
