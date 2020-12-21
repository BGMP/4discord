task :default => [:clean, :update, :mount]

task :clean do
  system("screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill")
end

task :update do
  system("git reset --hard")
  system("git clean -fd")
  system("git pull")
  system("bundle install")
end

task :mount do
  system("screen -dmS 4discord bash -c 'cd ./src/ && ruby 4discord.rb'")
end
