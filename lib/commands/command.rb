module BoiteABois
  module Commands

    class Command

      ALIAS = nil
      CATEGORY = 'default'
      SHOW = true
      CHANNELS = nil
      ROLES = nil
      MEMBERS = nil
      DESC = 'Command.'
      LISTEN = ['public', 'private']

      def self.exec(args, context)
        #NEEDED
      end

    end

  end
end
