module BoiteABois
  module Classes
    # Command class
    class Command
      # @return [String] command's name
      attr_reader :name

      # @return [Proc] command's function to trigger when it's called
      attr_reader :function
      
      # @return [String, nil] the alias of the command
      attr_reader :alias

      # @return [Boolean] if the command has to be shown in the help
      attr_reader :show

      # @return [String, nil] command's usage, for the help
      attr_reader :usage

      # @return [String, nil] command's description
      attr_reader :desc

      # @return [String] command's category, as defined in the config
      attr_reader :category

      # @return [Array, nil]
      attr_reader :channels

      # @return [Array, nil]
      attr_reader :roles

      # @return [Array, nil]
      attr_reader :members

      # @return [Array<String>] where the command should be listened for
      attr_reader :listen

      # Initialize the Command object
      #
      # @param data [Hash] command data
      def initialize(data)
        @name        = data[:name]
        @function    = data[:function]
        @alias       = data[:alias]
        @show        = data[:show]
        @usage       = data[:usage]
        @description = data[:desc]
        @category    = data[:category]
        @channels    = data[:channels]
        @roles       = data[:roles]
        @members     = data[:members]
        @listen      = data[:listen]
      end

      def to_s
        "#{@usage} : #{@description}"
      end
    end

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