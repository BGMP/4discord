SCREEN_NAME=4discord

screen -XS $SCREEN_NAME quit
screen -dmS $SCREEN_NAME bash -c 'cd src && ruby 4discord.rb'
echo "[SUCCESS] 4discord successfully mounted on screen" $SCREEN_NAME
