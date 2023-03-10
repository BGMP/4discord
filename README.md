<p align="center">
  <img height="200" width="200" src="https://raw.githubusercontent.com/BGMP/4discord/master/assets/logo.png"  alt=""/>
</p>

<h1 align="center">4discord</h1>

<h4 align="center">Discord bot which fetches random posts from any <a href="https://4chan.org/" target="_blank">4chan.org</a> board!</h4>

### Set up
  1. Invite **4discord** to your Discord server using 
[this invite link](https://discord.com/api/oauth2/authorize?client_id=780529113118539798&permissions=60416&scope=bot)!
  2. On your Discord server, you may configure the bot at Server Settings » Integrations.
  3. Make sure the channel where you want to use the bot at is marked as **NSFW** (Age Restricted Channel).
  4. All set! Now you should be able to use the bot on the channels you have defined.

### Commands
The bot uses slash commands as of its rewrite. Make sure to select the commands you want to execute and then provide
the arguments as Discord requests them via visual queues (use the Tab key to auto-complete).

The following list contains all available commands:

  * `/chan [board]`: Pull a random post from a 4chan board. Not providing a board will randomly pull from /o/!
  * `/chans [page]`: Display available 4chan boards.
  * `/4help`: Display general help for the bot.

### Running
Instructions on how to set the bot up internally, and on how to run it for development/testing purposes.

#### Prerequisites
* [Ruby 2.7.3](https://www.ruby-lang.org/)
  * OS X: [RVM](http://rvm.io) is recommended over the default OS X Ruby. Here's a one-liner:
`\curl -sSL https://get.rvm.io | bash -s stable --ruby`
* Ensure bundler is installed: `gem install bundle`
* From the project's root, run `bundle install` to download and install dependencies.

#### Launching
* Create a bot application on your [Discord applications portal](https://discord.com/developers/applications).
* Rename the [config.yml.secrets](https://github.com/BGMP/4discord/blob/master/config/config.yml.secrets) to `config.yml`.
* Complete the fields in `config.yml` with your bot's client id and token.
* Run the [4discord.rb](https://github.com/BGMP/4discord/blob/master/src/4discord.rb) file. (`ruby 4discord.rb`)

### Data Collection
4discord is proud to collect **NO** data. With the migration to slash commands and other features introduced by Discord
over time, there is no longer a need to store server IDs, channel IDs, or channel names like the bot used to do in the
past. 

### Background
This bot started as a small, fun project to approach, inspired by another
[4chan bot](https://github.com/Romejanic/4chan-Discord-Bot). In the end I decided to carry on and keep adding
features and fixing bugs, due to the massive support I received from friends and other people who enjoy reading 4chan
content!

As of October, 2022 the bot has been rewritten to support the newly introduced slash commands, and to comply with the
new limitations imposed by Discord such as Message Content being now a privileged intent. The old repository has been
archived and made private. All further development will be conducted in this repository instead.

### Disclaimer
Any contributors to 4discord's codebase are not responsible for anything you may pull from 4chan.org using the 4discord
bot. This bot is provided as a free resource open for anybody to use, therefore it is every server owner's
responsibility to moderate what the bot may pull from the site and post on their text channels.
