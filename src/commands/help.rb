require_relative 'command'

module BoiteABois
  module Commands
    class Help < Command

      CATEGORY = 'utilities'
      USAGE = 'help'
      DESC = 'Lister toutes les commandes disponibles'

      def self.exec(args, context)
        commands = $core.commands
        categories = $config['categories']
        commandList = {}
        commands.each do |name, command|
          if command.show && !command.alias
            commandList[command.category] = '' if commandList[command.category].nil?
            commandList[command.category] << "#{command}\n"
          end
        end
        context.send_message 'Voici la liste des commandes :'
        commandList.each do |cmd_category, commands|
          context.channel.send_embed categories[cmd_category] do |embed|
            embed.color = $config['color'].to_i
            embed.description = commands
          end
        end
      end
    end
  end
end