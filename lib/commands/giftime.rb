require_relative 'command'

module BoiteABois
  module Commands
    class Giftime < Command

      USAGE = 'giftime' # Command usage
      DESC = 'Envoyer un GIF aléatoire' # Command description

      GIF = [
        'https://imgur.com/a/KBZyYKm', # << Vous n'avez pas les bases >>
        'https://imgur.com/a/4jwuayw' # << Rêves bizarres >>
      ].freeze

      def self.exec(args, context)
        context.message.delete
        context.send "#{GIF.sample}"
      end

    end
  end
end