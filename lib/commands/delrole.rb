require_relative 'command'

module BecauseOfBot
  module Commands
    class Delrole < Command

      USAGE = 'delrole <rolename>+'
      DESC = 'Vous supprime un role'

      def self.exec(args, msg)
        roles = BecauseOfBot::Core::ROLES
        to_add = []
        okay = false
        roles.each do |id, role|
          if (role & args).any?
            args = (args - role)
            to_add << msg.server.role(id)
            okay = true
          end
        end
        if okay
          sendMsg = 'Role(s) supprimé(s)'
          if args != []
            sendMsg += " (Not found: #{args.join(', ')})"
          end
        else
          sendMsg = 'Aucun role(s) trouvé(s)'
        end
        msg.author.remove_role to_add
        msg.send_message sendMsg
      end

    end
  end
end