require_relative 'command'

module BoiteABois
  module Commands
    # The minesweeper game on Discord
    class Minesweeper < Command
      CATEGORY = 'games'
      USAGE = 'minesweeper [width] [height] [mines]'
      DESC = 'Générer une grille de démineur (par défaut 9x9 avec 10 mines)'

      def self.exec(args, context)
        width, height, mines = args.map(&:to_i)
        if width.nil?
          width = height = 9
          mines = 10
        end
        if mines <= 0
          context.send(':x: Veuillez mettre au moins une mine.')
          return
        elsif mines >= width * height
          context.send(':boom: Il y a trop de mines ! Réduisez leur nombre.')
          return
        end
        begin
          context.send(generate(width, height, mines))
        rescue Discordrb::Errors::MessageTooLong
          context.send('La grille est trop volumineuse. Essayez de réduire sa taille.')
        end
      end

      # Generate a minesweeper grid
      #
      # @param width [Integer] Grid's width
      # @param height [Integer] Grid's height
      # @param mines [Integer] The number of mines
      def self.generate(width = 9, height = 9, mines = 10)
        # Defining emojis
        emojis = %w[◻ :one: :two: :three: :four: :five: :six: :seven: :eight: 💣]
      
        # Generating the base table
        table = Array.new(height)
        table.each_index do |i|
          table[i] = Array.new(width)
        end
      
        # Adding mines 
        mines.times do
          mine_location = [rand(width - 1), rand(height - 1)]
          cell = table[mine_location[0]][mine_location[1]]
          redo if cell == emojis[9]
          table[mine_location[0]][mine_location[1]] = emojis[9]
        end
      
        # Generating numbers around mines
        height.times do |y|
          width.times do |x|
            if table[y][x] == emojis[9]
              next
            end
            mines = 0
      
            (-1..1).each do |i|
              (-1..1).each do |j|
                next if i == 0 && j == 0
                neighbor_cell_height = table[y + i]
                unless neighbor_cell_height == Array.new(x) || neighbor_cell_height.nil?
                  neighbor_cell = neighbor_cell_height[x + j]
                  mines += 1 if neighbor_cell == emojis[9]
                end
              end
            end
      
            table[y][x] = emojis[mines]
          end
        end
      
        # Generating the Discord style output
        result = ''
      
        table.each do |a|
          a.each do |x| 
            result += "||#{x}||"
          end
          result += "\n"
        end
        result
      end
    end
  end
end