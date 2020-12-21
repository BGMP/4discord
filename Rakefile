SCREEN_NAME = "4discord"

task :default => [:clean, :update, :mount]

task :clean do
  begin
    sh "screen -XS 4discord quit"
  rescue
    puts("[INFO] Status: NORMAL")
  end
end

task :update do
  puts("[INFO] Updating to the latest git revision...")
  sh "git reset --hard"
  sh "git clean -fd"
  sh "git pull"
  sh "bundle install"
end

task :mount do
  sh "screen -dmS #{SCREEN_NAME} bash -c 'cd src && ruby 4discord.rb'"
  puts("[INFO] 4discord successfully mounted on screen #{SCREEN_NAME}")
end
