require_relative 'command'

module BoiteABois
  module Commands
    class Pendu < Command

      USAGE = 'pendu <max_errors>'
      DESC = 'Jouer au fameux jeu du pendu'

      WORDS = File.read('assets/wordlist.txt').split("\n").freeze

      def self.exec(args, context)
        word = WORDS[rand(0..WORDS.length)]
        hidden_word = hide_word(word, '')
        letters = ''
        false_letters = []
        max_errors = args[0].to_i
        win = false
        
        play = context.send ":hugging: **#{context.user.mention} a démarré une partie de pendu !**"
        sleep(1)
        context.message.delete
        stats = BoiteABois::Classes::Statistics.new
        play.edit ":arrow_forward: `#{hidden_word}`\nErreurs restantes : #{max_errors}"
        context.channel.await(:message) do |event|
          trial_letter = event.content[0].capitalize
          stats.players[event.user.mention] = [] if stats.players[event.user.mention].nil?
          stats.players[event.user.mention] << trial_letter
          stats.letters << trial_letter
          event.message.delete
          if false_letters.include? trial_letter
            false
          else
            trial_word = hide_word(word, trial_letter + letters)
            if trial_word == hidden_word
              false_letters << trial_letter
            else
              hidden_word = trial_word
              letters << trial_letter
              if hidden_word == word
                context.send ":raised_hands: **Bravo ! Vous avez trouvé le mot #{word} !**"
                context.send "**:bar_chart: Statistiques :**\n\n#{stats.to_s}"
                win = true
              end
            end
            unless win
              if false_letters.length >= max_errors
                context.send ":cry: **C\'est perdu ! Retentez votre chance !**\n\nLe mot était **#{word}** !"
                context.send "**:bar_chart: Statistiques :**\n\n#{stats.to_s}"
                nil
              else
                play.edit ":arrow_forward: `#{hidden_word}`\nUtilisées : #{false_letters.join(', ').chomp(', ')}\nErreurs restantes : #{max_errors - false_letters.length}"
                false
              end
            end
          end
        end
      end

      # Hide a word to make the players gess it
      def self.hide_word(word, letters)
        word.gsub(/[^#{word[0]}#{letters}]/, '_ ')
      end
    end
  end
end