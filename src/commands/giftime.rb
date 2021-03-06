require_relative 'command'

module BoiteABois
  module Commands
    class Giftime < Command
      CATEGORY = 'fun'
      USAGE = 'giftime'
      DESC = 'Envoyer un GIF aléatoire'

      GIF_LIST = [
        'https://imgur.com/a/KBZyYKm', # << Vous n'avez pas les bases >>
        'https://imgur.com/a/4jwuayw', # << Rêves bizarres >>
        'https://tenor.com/view/traffic-fbiopen-up-raid-gif-13450966' # << FBI OPEN UP! >>
      ].freeze

      def self.exec(_args, context)
        context.message.delete
        context.send(GIF_LIST.sample)
      end
    end
  end
end
