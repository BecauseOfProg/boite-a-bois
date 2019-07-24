<div align="center">
  <img src="https://cdn.becauseofprog.fr/v2/projects/boite-a-bois.png" width="200" alt="logo">
  <h1>Boite à bois</h1>
  <h6><i>literally "box of wood"</i></h6>
  <h3>The French Discord bot of the BecauseOfProg.</h3>
  <a href="https://becauseofprog.fr">Website</a> - <a href="https://discord.becauseofprog.fr">Discord server</a>
</div>

- [🌈 Features](#-features)
- [📲 Requirements](#-requirements)
- [⏩ First start](#-first-start)
- [🔧 Creating commands](#-creating-commands)
- [📚 Creating database models](#-creating-database-models)
- [📜 Credits](#-credits)
- [🔐 License](#-license)

## 🌈 Features

- Play games many games, singleplayer or multiplayer
- Get the current weather and weather forecast for any city in the world
- Send very nice GIF
- Search for posts and users of [our blog](https://becauseofprog.fr)

## 📲 Requirements

- Ruby 2.1+
- A MongoDB database
- [Discordrb gem](https://rubygems.org/gems/discordrb/versions/3.2.1)
- [JSON gem](https://rubygems.org/gems/json/versions/2.1.0)
- [OpenWeatherMap gem](https://rubygems.org/gems/openweathermap)
- [Mongocore gem](https://rubygems.org/gems/mongocore)

## ⏩ First start

To use it, you must setup config.json (there is example with the samples).
When it's configured, you can start the bot with this command :

```ruby
ruby run.rb
```

After that, the bot is ready and you can add it to your guild ([Guide](https://discordapp.com/developers/docs/topics/oauth2#bot-authorization-flow))

## 🔧 Creating commands

To create a new command, you only must create a file in /src/commands/ of the name of your command.
In this file, you have to require command.rb and set the namespace to BoiteABois::Commands.
The class should inherit from Command.
When you add a new command, you must restart the bot.
Here is an example :

```ruby
require_relative 'command'

module BoiteABois
  module Commands
    class Example < Command

      CATEGORY = 'default' # Command category, defined in the config
      USAGE = 'example' # Command usage
      DESC = 'Description' # Command description
      #LISTEN = ['public', 'private'] # Listen for messages from public or private channel
      #ALIAS = 'another_command' # Alias to another command
      #SHOW = true # Visibility in the command list
      #CHANNELS = [] # Array of authorized channels
      #ROLES = [] # Array of authorized user roles
      #MEMBERS = [] # Array of authorized members

      def self.exec(args, context)
        # context is an instance of Discordrb::Message
        # args is an array of arguments
      end

    end
  end
end
```

## 📚 Creating database models

All the models are defined in two files :

- `lib/db/models` : the Ruby class
- `lib/db/schemas` : the database schema, if required

The schemas are in the YML format. All is documented [on the mongocore gem page](https://github.com/fugroup/mongocore)

## 📜 Credits

- Library : [DiscordRB](https://github.com/meew0/discordrb)
- Developers :
  - [Whaxion](https://github.com/whaxion) : first base
  - [Exybore](https://github.com/exybore) : maintainor, actual main developer

## 🔐 License

[GNU GPL v3](LICENSE)
