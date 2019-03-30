require_relative 'src/commands/command'
require_relative 'lib/db/core'
require_relative 'lib/classes'

module BoiteABois
  class Core
    # return [Hash<Commands::Command>] all the commands defined in the bot
    attr_reader :commands

    # return [OpenWeatherMap::API] The weather API object to use for some commands
    attr_reader :weather_api

    # Bot version
    VERSION = '1.1.2'

    # Library used for the bot
    LIBRARY = 'DiscordRB'

    # Initialize the bot core.
    #
    # @param bot [Discordrb::Bot] the Discord Bot class
    def initialize(bot)
      raise ArgumentError, 'Not an instance of Discordrb::Bot' unless bot.is_a? Discordrb::Bot
      @bot = bot
      @core_folder = File.dirname(__FILE__)
      @weather_api = OpenWeatherMap::API.new($config['weather_api_key'], 'fr', 'metric')
      @commands = listCommands()
    end

    # Trigger a command
    #
    # @param cmd [String] command's name
    # @param args [Array] arguments passed to the command
    # @param context [Discordrb::Event::MessageEvent] the command context
    def onCommand(cmd, args, context)
      if @commands[cmd.downcase].nil?
        context.send_message "❓ Commande inconnue. Faites #{prefix}help pour avoir la liste complète des commandes autorisées."
      else
        command = @commands[cmd.downcase]

        if context.channel.private?
          return unless command.listen.include?('private')
        else
          return unless command.listen.include?('public')
        end

        cmd = loadCommand cmd.downcase
        have_alias = true unless command.alias.nil?
        while have_alias
          have_alias = false
          cmd = loadCommand(command.alias)
          have_alias = true unless command.alias.nil?
        end
        authorized = false

        # Verifying if the command is in the good channel - if not, then output an error message
        unless context.channel.private?
          unless command.channels.nil?
            unless command.channels.include?(context.channel.id)
              context.send_message ':x: Vous n\'avez pas la permission d\'exécuter cette commande dans ce salon.'
              return
            end
          end
        end
        
        # Verifying if there is members or roles restrictions - if yes, do the check - if no, authorize the command
        if !command.members.nil?
          authorized = true if command.members.include?(context.user.id)
        elsif !command.roles.nil?
          context.user.roles.each do |role|
            authorized = true if command.roles.include?(role.id)
          end
        else
          authorized = true
        end

        authorized ? command.function.call(args, context) : context.send_message(':x: Vous n\'avez pas la permission d\'exécuter cette commande.')
      end
    end

    private

    # List all the available commands
    #
    # @param guild_id [Integer] (unused yet)
    def listCommands(guild_id = nil)
      commands = {}
      prefix = $config['prefix']
      Dir["#{@core_folder}/src/commands/*.rb"].each do |path|
        resp = Regexp.new("([a-z0-9]+)\.rb$").match(path)
        if resp != nil && resp[1] != 'command'
          cmd_name = resp[1]
          cmd = loadCommand(cmd_name)
          data = {
            name:     cmd_name,
            function: lambda { |args, context| cmd.exec(args, context) },
            alias:    (cmd::ALIAS),
            show:     (cmd::SHOW),
            usage:    (cmd.const_defined?('USAGE') ? "#{prefix}#{cmd::USAGE.to_s}" : "#{prefix}#{cmd_name}"),
            desc:     (cmd::DESC),
            category: (cmd::CATEGORY),
            channels: (cmd::CHANNELS),
            roles:    (cmd::ROLES),
            members:  (cmd::MEMBERS),
            listen:   (cmd::LISTEN)
          }
          commands[cmd_name] = Classes::Command.new(data)
        end
      end
      commands
    end

    # Load a command from the files
    #
    # @param command [String] the command's name
    def loadCommand(command)
      require_relative "src/commands/#{command}"
      eval "Commands::#{command.capitalize}"
    end
  end
end