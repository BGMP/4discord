task :default => [:update, :mount]

task :update do
  system("git reset --hard")
  system("git clean -fd")
  system("git pull")
  system("bundle install")
end

task :mount do
  system("screen -dmS 4discord bash -c 'cd ./src/ && ruby 4discord.rb'")
end
