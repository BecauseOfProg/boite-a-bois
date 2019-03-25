require_relative 'command'

module BoiteABois
  module Commands
    class Minesweeper < Command

      CATEGORY = 'games'
      USAGE = 'minesweeper'
      DESC = 'Jouer au démineur'
      CHANNELS = [541314079298551819]

      def self.exec(args, context)
        context.send generate(1)
      end

      def self.generate(level)
        # Defining emojis and levels
        emojis = ['◻', ':one:', ':two:', ':three:', ':four:', ':five:', ':six:', ':seven:', ':eight:', '💣']
        levels = {
          1 => {
            width: 9,
            height: 9,
            mines: 10
          },
          2 => {
            width: 16,
            height: 16,
            mines: 40
          },
          3 => {
            width: 16,
            height: 40,
            mines: 99
          }
        }
      
        # Generating the base table
        level = levels[level]
        table = Array.new(level[:height])
        table.each_index do |i|
          table[i] = Array.new(level[:width])
        end
      
        # Adding mines 
        level[:mines].times do
          mine_location = [rand(level[:width] - 1), rand(level[:height] - 1)]
          cell = table[mine_location[0]][mine_location[1]]
          redo if cell == emojis[9]
          table[mine_location[0]][mine_location[1]] = emojis[9]
        end
      
        # Generating numbers around mines
        level[:height].times do |height|
          level[:width].times do |width|
            if table[height][width] == emojis[9]
              next
            end
            mines = 0
      
            (-1..1).each do |i|
              (-1..1).each do |j|
                next if i == 0 && j == 0
                neighbor_cell_height = table[height + i]
                unless neighbor_cell_height == Array.new(level[:width]) || neighbor_cell_height.nil?
                  neighbor_cell = neighbor_cell_height[width + j]
                  mines += 1 if neighbor_cell == emojis[9]
                end
              end
            end
      
            table[height][width] = emojis[mines]
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