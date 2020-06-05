require_relative 'command'

module BoiteABois
  module Commands
    class Tictactoe < Command
      CATEGORY = 'games'
      USAGE = 'tictactoe <player>'
      DESC = 'Démarrer un morpion contre un autre joueur'

      NUMBERS = %w[:one: :two: :three:]

      PLAYS = {
        blank: ':white_large_square:',
        cross: ':x:',
        circle: ':o:'
      }

      VOID = ':black_large_square:'
      BLANK = PLAYS[:blank]
      WINNING = [
        %w[11 22 33],
        %w[13 22 31],
        %w[11 12 13],
        %w[21 22 23],
        %w[31 32 33],
        %w[11 21 31],
        %w[12 22 32],
        %w[13 23 33],
      ]

      def self.exec(args, context)
        players = [
          {
            user: context.author,
            type: :cross
          },
          {
            user: context.message.mentions[0],
            type: :circle
          }
        ]
        grid = [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]

        message = context.send(generate(grid))

        turn = 0
        notice = true
        notice_message = nil
        loop do
          in_game = players[turn % 2]
          notice_message = context.send("**:arrow_right: #{in_game[:user].mention}, à votre tour** (vous êtes #{PLAYS[in_game[:type]]})\n*Pour quitter la partie, envoyez `stop`.") if notice

          answer = in_game[:user].await!({ in: context.channel.id, timeout: 120 })

          if answer.nil?
            context.send(':clock_2: :x: Le temps pour jouer est écoulé, la partie est annulée.')
            break
          end
          if answer.content == 'stop'
            context.send(":stop_sign: Arrêt de la partie prononcé par #{in_game[:user].mention}")
            break
          end

          cell_numbers = answer.content
          answer.message.delete

          column = cell_numbers[0].to_i - 1
          row = cell_numbers[1].to_i - 1
          cell = grid[row][column]
          if cell.nil?
            grid[row][column] = in_game[:type]
            message.edit(generate(grid))
            notice = true
            notice_message.delete

            WINNING.each do |config|
              k = 0
              config.each do |place|
                column = place[0].to_i - 1
                row = place[1].to_i - 1
                k += 1 if grid[row][column] == in_game[:type]
              end
              if k == 3
                context.send_message(":tada: #{in_game[:user].mention} a gagné la partie!")
                return
              end
            end

            turn += 1
          else
            context.send_temporary_message("**:arrows_counterclockwise: Case déjà prise. Merci d'en choisir une autre.**", 3)
            notice = false
          end
        end
      end

      def self.generate(grid)
        output = VOID.clone
        3.times do |i|
          output << NUMBERS[i]
        end
        output << "\n"

        grid.each.with_index do |row, index|
          output << NUMBERS[index]
          row.each do |column|
            output << get_emoji(column)
          end
          output << "\n"
        end
        output
      end

      def self.get_emoji(column)
        column.nil? ? BLANK : PLAYS[column]
      end
    end
  end
end
