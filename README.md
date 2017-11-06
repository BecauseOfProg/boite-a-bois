#BecauseOfBot

The Discord bot of the BecauseOfProg

Features:
  - Adding/removing guild role to user
  - List of available commands
  - Easily extensible commands
  
##First start

To use it, you must setup config.json and roles.json (there is example with the samples).
When it's configured, you can start the bot with a
```ruby
ruby run.rb
```
After that, the bot is ready and you can add it to your guild ([Guide](https://discordapp.com/developers/docs/topics/oauth2#bot-authorization-flow))

##Creating a new command

To create a new command, you only must create a file in /lib/commands/ of the name of your command.
In this file, you have to require command.rb and set the namespace to BecauseOfProg::Commands.
The class should inherit from Command.
When you add a new command, you must restart the bot.
Here is an example (example.rb):
```ruby
require_relative 'command'

module BecauseOfBot
  module Commands
    class Example < Command

      USAGE = 'example' # Command usage
      DESC = 'Description' # Command description
      #ALIAS = 'another_command' # Alias to another command
      #SHOW = true # Visibility in the command list

      def self.exec(args, msg)
        # msg is an instance of Discordrb::Message
        # args is an array of arguments
      end

    end
  end
end
```

##Credits
 - Library: [DiscordRB](https://github.com/meew0/discordrb)
 - Main developers: [Whaxion](https://github.com/whaxion)
 - License: [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)