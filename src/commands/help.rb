require_relative 'command'

module BoiteABois
  module Commands
    class Help < Command

      CATEGORY = 'utilities'
      USAGE = 'help'
      DESC = 'Lister toutes les commandes disponibles'

      def self.exec(_args, context)
        commands = $core.commands
        categories = $config['categories']
        command_list = {}
        commands.each do |_, command|
          if command.show && !command.alias
            command_list[command.category] = '' if command_list[command.category].nil?
            command_list[command.category] << "#{command}\n"
          end
        end
        embed = BoiteABois::Utils::embed(title: 'Liste des commandes')
        command_list.each do |cmd_category, command|
          embed.fields << Discordrb::Webhooks::EmbedField.new(
            name: categories[cmd_category],
            value: command
          )
        end
        context.channel.send_embed('', embed)
      end
    end
  end
end