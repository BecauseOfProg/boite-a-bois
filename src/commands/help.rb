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
        embed = BoiteABois::Utils::embed(title: 'Liste des commandes')
        commandList.each do |cmd_category, commands|
          embed.fields << Discordrb::Webhooks::EmbedField.new(
            name: categories[cmd_category],
            value: commands
          )
        end
        context.channel.send_embed('', embed)
      end
    end
  end
end