<p align="center">
  <img height="200" width="200" src="https://github.com/BGMP/4discord/blob/master/assets/logo.png" />
</p>

<h1 align="center">4discord</h1>
<h4 align="center">Discord bot which fetches random posts from any <a href="https://4chan.org/" target="_blank">4chan.org</a> board!</h4>

### Set up

  1. Invite **4discord** to your Discord server using [this invite link](https://discord.com/api/oauth2/authorize?client_id=780529113118539798&permissions=60416&scope=bot)!
  2. Use the `/4channel <channel>` command to hook the bot to an existing text channel on your server. (i.e: `/4channel example_channel`).
        * Using /4channel requires you to have administrative permissions on the server.
  3. All set! Now you should be able to use the rest of the bot's commands on the channel you have hooked it to.

### Commands

Every command for the 4discord bot
	
  * `/4channel <channel>`: Hook 4discord to an existing text channel on your server.
  * `/4help`: Display general help for the bot.
  * `/chans <page>`: Display available 4chan boards.
  * `/chan <board>`: Pull a random post from a 4chan board. Not providing a board will randomly pull from /b/!
  * `/chan replies`: Pulls some replies to the latest randomly pulled post within a 2 minutes window.

### Running

Instructions on how to set the bot up internally, and on how to run it for development/testing purposes.

#### Prerequisites
* [Ruby 2.6.6](https://www.ruby-lang.org/)
  * OS X: [RVM](http://rvm.io) is recommended over the default OS X Ruby. Here's a one-liner: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
* Ensure bundler is installed: `gem install bundle`
* From the project's root, run `bundle install` to download and install dependencies.

#### Launching
* Create a bot application on your [Discord applications portal](https://discord.com/developers/applications).
* Rename the [config.yml.secrets](https://github.com/BGMP/4discord/blob/master/config/config.yml.secrets) to `config.yml`.
* Complete the fields in `config.yml` with your bot's client id and token.
* Run the [4discord.rb](https://github.com/BGMP/4discord/blob/master/src/4discord.rb) file. (`ruby 4discord.rb`)

### Background

This bot started as a small, fun project to approach, inspired by another [4chan bot](https://github.com/Romejanic/4chan-Discord-Bot). In the end I decided to carry on and keep adding features and fixing bugs, due to the massive support I received from friends and other people who enjoy reading 4chan content!

### Contributing

4discord's codebase is completely open source, and is licenced under the MIT licence. Contributions are highly appreciated! You may leave a star if you would like too! :heart:
