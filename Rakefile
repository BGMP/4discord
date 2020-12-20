task :default => [:clean, :update, :mount]

task :clean do
  sh "screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill"
end

task :update do
  sh "git reset --hard"
  sh "git clean -fd"
  sh "git pull"
  sh "bundle install"
end

task :mount do
  sh "screen -dmS 4discord bash -c 'cd ./src/ && ruby 4discord.rb'"
end
