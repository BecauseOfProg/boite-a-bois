require_relative 'lib/commands/command'
require_relative 'lib/constants'
require_relative 'lib/classes'

module BoiteABois
  class Core

    attr_reader :commands

    attr_reader :config

    VERSION = '1.0'
    LIBRARY = 'DiscordRB'

    def initialize(bot)
      raise ArgumentError, 'Not an instance of Discordrb::Bot' unless bot.is_a? Discordrb::Bot
      @bot = bot
      @core_folder = File.dirname(__FILE__)
      @config = JSON.parse(File.read(@core_folder + '/config.json'))
      @commands = listCommands()
      @bot.debug 'Core initialized'
    end

    def listCommands(guild_id = nil)
      commands = {}
      prefix = @config['prefix']
      Dir["#{@core_folder}/lib/commands/*.rb"].each do |path|
        resp = Regexp.new("([a-z0-9]+)\.rb$").match(path)
        if resp != nil && resp[1] != 'command'
          cmd_name = resp[1]
          cmd = loadCommand(cmd_name)
          commands[cmd_name] = {
            alias:    (cmd::ALIAS if cmd.const_defined?('ALIAS')),
            show:     (cmd::SHOW if cmd.const_defined?('SHOW')),
            usage:    (cmd.const_defined?('USAGE') ? "#{prefix}#{cmd::USAGE.to_s}" : "#{prefix}#{cmd_name}"),
            desc:     (cmd::DESC if cmd.const_defined?('DESC')),
            category: (cmd::CATEGORY if cmd.const_defined?('CATEGORY')),
            channels: (cmd::CHANNELS if cmd.const_defined?('CHANNELS'))
          }
        end
      end
      return commands
    end

    def onCommand(cmd, args, context)
      prefix = @config['prefix']
      cmdname = cmd.downcase
      if !context.channel.private?
        folder = 'commands'
      else
        return
      end
      path = "#{@core_folder}/lib/#{folder}/#{cmdname}.rb"
      if File::exists? path
        cmd = loadCommand cmdname
        have_alias = true if cmd.const_defined?('ALIAS') == true && cmd::ALIAS != false
        while have_alias
          have_alias = false
          cmd = loadCommand cmd::ALIAS
          have_alias = true if cmd.const_defined?('ALIAS') == true && cmd::ALIAS != false
        end
        if cmd.const_defined?('CHANNELS')
          p context.channel.id
          p cmd::CHANNELS
          if cmd::CHANNELS.include? context.channel.id
            cmd::exec args, context
          else
            context.send_message ':x: Vous n\'avez pas la permission d\'exécuter cette commande ici.'
          end
        else
          cmd::exec args, context
          # if cmd.const_defined?('ROLES')
          #   if cmd::ROLES.include? context.user.
          # else
          # end
        end
      else
        context.send_message "Commande inconnue: faites #{prefix}help pour avoir de l\'aide"
      end
    end

    def stop
      @bot.stop
    end

    def debug(msg)
      @bot.debug msg
    end

    private

      def loadCommand(cmd)
        require_relative "lib/commands/#{cmd}"
        eval "Commands::#{cmd.capitalize}"
      end

  end

end