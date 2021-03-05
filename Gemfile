# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'                         # Resolve OpenSSH problems with capistrano
gem "capistrano", "~> 3.14", require: false                   # Deployment
gem 'capistrano-bundler', '~> 2.0', require: false            # Capistrano bundler integration
gem 'discordrb', github: 'shardlab/discordrb', tag: 'v3.4.2'  # Discord API for Ruby
gem 'ed25519', '>= 1.2', '< 2.0'                              # Resolve OpenSSH problems with capistrano
gem 'json', '~> 2.3', '>= 2.3.1'                              # Ensure JSON support for 4chan's API interaction
gem 'nokogiri', '~> 1.10', '>= 1.10.10'                       # HTML parsing
gem 'rvm1-capistrano3', require: false                        # Capistrano rvm integration
gem 'sqlite3', '~> 1.4', '>= 1.4.2'                           # SQLite, as the database for the bot
gem 'time-hash', '~> 0.1.0'                                   # Hashes with expiring keys
