# frozen_string_literal: true

server 'network.bgmp.cl', :user => 'deploy', :roles => 'app', :primary => true

set :ssh_options, {
  :keys => %w(C:/Users/BGM/.ssh/network),
  :auth_methods => %w(publickey),
  :forward_agent => true
}
