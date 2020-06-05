require_relative 'command'

module BoiteABois
  module Commands
    class Test < Command
      USAGE = 'test'
      DESC = "n'utilise pas ça s'il te plait"
      SHOW = false
      LISTEN = ['private']

      def self.exec(_args, context)
        m = context.send 'Choisit une réaction !'
        m.react('🍺')
        m.react('🍷')

        event = context.bot.add_await!(Discordrb::Events::ReactionAddEvent)
        context.send(case event.emoji.name
                     when '🍺' then "j'aime pas trop la bière en vrai"
                     when '🍷' then "Je kiffe le vin ! :flag_fr:"
                     else "faudrait p'tet réagir avec ce que je t'ai filé nan ?"
                     end)
      end
    end
  end
end
