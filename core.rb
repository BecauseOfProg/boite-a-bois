require 'json'

module BecauseOfBot

  require_relative 'lib/commands/command'

  class Core

    VERSION = '0.1'
    LIBRARY = 'DiscordRB'

    ROLES = JSON.parse(File.read('roles.json'))

    def initialize(bot)
      raise ArgumentError, 'Not an instance of Discordrb::Bot' unless bot.class.to_s == "Discordrb::Bot"
      @bot = bot
      @config = JSON.parse(File.read('config.json'))
      @bot.debug 'Core initialized'
    end

    def listCommands(guild_id)
      commands = {}
      prefix = config('prefix')
      Dir["#{config('core_folder')}/lib/commands/*.rb"].each do |command|
        regex = Regexp.new "([a-z0-9]+)\.rb$"
        resp = regex.match command
        if resp != nil && resp[1] != 'command'
          cmd = loadCommand(resp[1])
          commands[resp[1]] = {}
          commands[resp[1]]['alias'] = cmd::ALIAS if cmd.const_defined? 'ALIAS'
          commands[resp[1]]['show'] = cmd::SHOW if cmd.const_defined? 'SHOW'
          commands[resp[1]]['usage'] = prefix + cmd::USAGE.to_s if cmd.const_defined? 'USAGE'
          commands[resp[1]]['usage'] = prefix + resp[1] unless cmd.const_defined? 'USAGE'
          commands[resp[1]]['desc'] = cmd::DESC if cmd.const_defined? 'DESC'
        end
      end
      return commands
    end

    def onCommand(cmd, args, msg)
      prefix = config('prefix')
      cmdname = cmd.downcase
      if !msg.channel.private?
        folder = 'commands'
      else
        return
      end
      path = "#{config('core_folder')}/lib/#{folder}/#{cmdname}.rb"
      if File::exists? path
        cmd = loadCommand cmdname
        have_alias = true if cmd.const_defined?('ALIAS') == true && cmd::ALIAS != false
        while have_alias
          have_alias = false
          cmd = loadCommand cmd::ALIAS
          have_alias = true if cmd.const_defined?('ALIAS') == true && cmd::ALIAS != false
        end
        cmd::exec args, msg
      else
        message = 'Commande inconnue: faites %prefix%help pour avoir de l\'aide'
        message = message.gsub /%prefix%/i, prefix
        msg.send_message message
      end
    end

    def stop
      @bot.stop
    end

    def debug(msg)
      @bot.debug msg
    end
    
    def config(name)
      @config[name]
    end

    private

      def loadCommand(cmd)
        require_relative "lib/commands/#{cmd}"
        eval "Commands::#{cmd.capitalize}"
      end

  end

end