task :update do
  system("git reset --hard")
  system("git clean -fd")
  system("git pull")
end

task :mount do
  system("screen -dmS 4discord && ruby src/4discord.rb")
end
