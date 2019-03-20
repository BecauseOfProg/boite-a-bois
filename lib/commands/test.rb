require_relative 'command'

module BoiteABois
  module Commands
    class Test < Command

      USAGE = 'test'
      DESC = 'tese'
      SHOW = false

      def self.exec(args, context)
        m = context.send 'Choisis une réaction !'
        m.react '🍺'
        m.react '🍷'

        event = context.bot.add_await!(Discordrb::Events::ReactionAddEvent)
        p event
        context.send case event.emoji.name
        when '🍺' then 'j\'aime pas trop la bière en vrai'
        when '🍷' then 'Je kiffe le vin ! :flag_fr:'
        else 'faudrait p\'tet réagir avec ce que je t\'ai filé nan ?'
        end
      end

    end
  end
end