module BoiteABois
  module Commands
    class Puissancequatre < Command
      CATEGORY = 'games'
      USAGE = 'puissancequatre <player>'
      DESC = 'Jouer au Puissance 4 contre un autre joueur'
      LISTEN = %w(public)

      NUMBERS = %w[:one: :two: :three: :four: :five: :six: :seven:]
      PLAYS = {
        blank: ':white_large_square:',
        yellow: ':yellow_circle:',
        red: ':red_circle:'
      }
      BLANK = PLAYS[:blank]

      def self.exec(args, context)
        players = [
          {
            user: context.author,
            type: :yellow
          },
          {
            user: context.message.mentions[0],
            type: :red
          }
        ]
        grid = [
          [],
          [],
          [],
          [],
          [],
          [],
          []
        ]

        message = context.send(generate(grid))

        turn = 0
        notice = true
        notice_message = nil
        loop do
          in_game = players[turn % 2]
          notice_message = context.send_temporary_message("**:arrow_right: #{in_game[:user].mention}, à votre tour** (vous êtes #{PLAYS[in_game[:type]]})\n*Pour quitter la partie, envoyez `stop`.*", 2) if notice

          answer = in_game[:user].await!({ in: context.channel.id, timeout: 120 })

          if answer.nil?
            context.send('**:clock_2: :x: Le temps pour jouer est écoulé, la partie est annulée.**')
            break
          end
          if answer.content == 'stop'
            context.send("**:stop_sign: Arrêt de la partie prononcé par #{in_game[:user].mention}**")
            break
          end

          cell_number = answer.content.to_i - 1
          answer.message.delete

          if cell_number < 0 || cell_number > 6
            context.send_temporary_message("**:arrows_counterclockwise: Rangée invalide.**", 3)
            notice = false
            redo
          end

          cell = grid[cell_number]
          if cell.length > 6
            context.send_temporary_message("**:arrows_counterclockwise: Rangée invalide.**", 3)
            notice = false
            redo
          end

          grid[cell_number].unshift(in_game[:type])
          message.edit(generate(grid))

          turn += 1
          if turn > 42
            context.send_message("**:shrug: La partie n'a pas de gagnant.**")
            return
          end

          notice = true
        end
      end

      def self.generate(grid)
        content = NUMBERS.join('')
        filled_rows = []
        grid.each do |row|
          filled_row = []
          (6 - row.length).times { filled_row.push(BLANK) }
          row.each { |piece| filled_row.push(PLAYS[piece]) }

          filled_rows.push(filled_row)
        end

        p grid
        p filled_rows

        6.times do |row|
          content << "\n"
          7.times do |column|
            content << filled_rows[column][row]
          end
        end

        content
      end
    end
  end
end
