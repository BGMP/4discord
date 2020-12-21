task :default => [:clean, :update, :mount]

task :clean do
  sh "screen -XS 4discord quit"
end

task :update do
  sh "git reset --hard"
  sh "git clean -fd"
  sh "git pull"
  sh "bundle install"
end

task :mount do
  sh "screen -dmS 4discord bash -c 'cd src && ruby 4discord.rb'"
end
