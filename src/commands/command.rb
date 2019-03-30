module BoiteABois
  module Commands
    # The main command class, from which all commands inherit.
    class Command

      # @return [nil, String] The alias of the command
      ALIAS = nil

      # @return [String] The command category
      CATEGORY = 'default'

      # @return [Boolean] If the command is showed or not in the help message
      SHOW = true

      # @return [nil, Array<Integer>] The channels in which the command is authorized
      CHANNELS = nil

      # @return [nil, Array<Integer>] Roles that have the permission to execute the command
      ROLES = nil

      # @return [nil, Array<Integer>] Members that have the permission to execute the command
      MEMBERS = nil

      # @return [String] The command description
      DESC = 'Command.'

      # @return [Array<String>] The context in which the command will listen. Can be :
      #   - public : in a server channel
      #   - private : in a private message channel
      # Can be one of them or both.
      LISTEN = ['public', 'private']

      # Execute the requested command.
      #
      # @param args [Array] List of arguments
      # @param context [Discordrb::Events::MessageEvent] The context in which the command is executed
      def self.exec(args, context)
        #NEEDED
      end

    end

  end
end
