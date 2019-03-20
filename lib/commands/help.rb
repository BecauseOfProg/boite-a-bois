require_relative 'command'

module BoiteABois
  module Commands
    class Help < Command

      USAGE = 'help'
      DESC = 'Lister toutes les commandes disponibles'

      def self.exec(args, msg)
        commands = $core.listCommands msg.server.id
        helpMsg = ''
        commands.each do |name, command|
          if command['show'] == true && command['alias'] == false
            helpMsg += "#{command['usage']} : #{command['desc']}\n"
          end
        end
        help = 'Voici la liste des commandes %USER%'
        help = help.gsub /%user%/i, "<@!#{msg.author.id}>"
        msg.channel.send_embed help do |embed|
          embed.color = 2001125
          embed.title = 'Commandes'
          embed.description = helpMsg
          embed.url = $core.config('website')
        end
      end

    end
  end
end