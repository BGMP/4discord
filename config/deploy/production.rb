# frozen_string_literal: true

server '4discord.bgmp.cl', :user => 'deploy', :roles => 'app', :primary => true

set :ssh_options, {
  :keys => %w(C:/Users/BGM/.ssh/4discord),
  :auth_methods => %w(publickey),
  :forward_agent => true
}
