require_relative 'command'

module BoiteABois
  module Commands
    class Chifoumi < Command

      CATEGORY = 'games'
      USAGE = 'chifoumi'
      DESC = 'Démarrer une partie de chifoumi'
      CHANNELS = [559836030874812436]

      ROCK = '✊'
      PAPER = '🤚'
      SCISSORS = '✌'

      SHOTS = [ROCK, PAPER, SCISSORS]

      COMBOS = {
      # USER     + BOT      => nil / 'user' / 'bot'
        ROCK     + ROCK     => nil,
        PAPER    + ROCK     => 'user',
        SCISSORS + ROCK     => 'bot',
        ROCK     + PAPER    => 'bot',
        PAPER    + PAPER    => nil,
        SCISSORS + PAPER    => 'user',
        ROCK     + SCISSORS => 'user',
        PAPER    + SCISSORS => 'bot',
        SCISSORS + SCISSORS => nil
      }

      def self.exec(args, context)
        rounds = []
        round_number = 0
        wins = {
          bot: 0,
          user: 0
        }

        play = context.send '👉 **Chioumi - Chargement...**'
        play.react ROCK
        play.react PAPER
        play.react SCISSORS
        context.message.delete
        until wins[:bot] == 3 or wins[:user] == 3
          round_number += 1
          message = "👉 **Chioumi - #{context.user.mention} VS Boîte à bois\n#{wins[:user]} - #{wins[:bot]}**\n"
          rounds.each do |round|
            message << "\n#{round[0]} - #{round[1]}"
          end
          play.edit message
          shot = SHOTS.sample
          event = context.bot.add_await!(Discordrb::Events::ReactionAddEvent)
          next unless event.user == context.user
          case COMBOS[event.emoji.name + shot]
          when 'user' then wins[:user] += 1
          when 'bot' then wins[:bot] += 1
          end
          rounds << [event.emoji.name, shot]
          play.delete_reaction(context.user, event.emoji.name)
        end
        score = "#{wins[:user]} à #{wins[:bot]}"
        if wins[:user] == 3
          context.send "**🙌 Bravo, vous avez gagné #{score} !**"
        else
          context.send "**😥 Vous avez perdu #{score}... Retentez votre chance !**"
        end
      end
    end
  end
end