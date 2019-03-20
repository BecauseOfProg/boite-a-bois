module BoiteABois
  module Classes
    # Pendu statistics class
    class Statistics
      # @return [Time] time when the game started
      attr_reader :start_time

      # @return [Array<String>] all played letters
      attr_accessor :letters

      # @return [Hash<Array<String>>] all letters tried by each player
      attr_accessor :players

      # Creates a new Statistics object
      #
      # @param start_time [Time] time when the game started
      def initialize
        @start_time = Time.now
        @letters = []
        @players = {}
      end

      # @return [Integer] elapsed time since the beginning of the game
      def elapsed_time
        (Time.now - @start_time).to_i
      end

      # @return [String] pretty-formated statistics
      def to_s
        message = ":clock4: Temps écoulé : #{elapsed_time} secondes\n:capital_abcd: Lettres jouées (global) : #{@letters.join(', ').chomp(', ')}\n:abcd: Lettres jouées (joueurs) :\n"
        players.each do |mention, letters|
          message << "\n#{mention} : #{letters.join(', ').chomp(', ')}"
        end
        message
      end
    end
  end
end