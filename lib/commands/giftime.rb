require_relative 'command'

module BoiteABois
  module Commands
    class Giftime < Command

      CATEGORY = 'fun'
      USAGE = 'giftime'
      DESC = 'Envoyer un GIF aléatoire'

      GIF = [
        'https://imgur.com/a/KBZyYKm', # << Vous n'avez pas les bases >>
        'https://imgur.com/a/4jwuayw' # << Rêves bizarres >>
      ].freeze

      def self.exec(args, context)
        context.message.delete
        context.send GIF.sample
      end

    end
  end
end