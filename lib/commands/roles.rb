require_relative 'command'

module BecauseOfBot
  module Commands
    class Roles < Command
      USAGE = 'roles'
      DESC = 'Lister les roles disponibles'

      def self.exec(args, msg)

        roles = BecauseOfBot::Core::ROLES

        embedMsg = "Liste des roles\n"

        roles.each do |id, role|
          embedMsg = "#{embedMsg}\t- #{role[0].to_s} => #{role[1].to_s}\n"
        end

        msg.channel.send_embed '' do |embed|
          embed.color = 2001125
          embed.description = embedMsg
          embed.url = $core.config('website')
        end

      end

    end
  end
end