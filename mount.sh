SCREEN_NAME=4discord

screen -XS $SCREEN_NAME quit

git reset --hard
git clean -fd
git pull
bundle install

screen -dmS $SCREEN_NAME bash -c 'cd src && ruby 4discord.rb' $SCREEN_NAME
