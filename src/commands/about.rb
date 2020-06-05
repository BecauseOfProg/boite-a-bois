require_relative 'command'

module BoiteABois
  module Commands
    class About < Command
      CATEGORY = 'utilities'
      USAGE = 'about'
      DESC = 'Avoir des informations sur le robot'

      def self.exec(_args, context)
        embed = BoiteABois::Utils::embed(
          title: 'À propos',
          thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: $config['illustration']),
          description: "Boîte à bois est un robot Discord créé par la BecauseOfProg dans le but d'avoir de nombreux utilitaires, mais surtout des jeux.
Son code source est ouvert à tous : n'hésitez-pas à contribuer à son développement !

🔨 Version : #{$config['version']}
🌐 Site Internet : #{$config['website']}
💻 Mainteneur : #{$config['maintainer']['name']} (#{$config['maintainer']['link']})"
        )
        context.send_embed('', embed)
      end
    end
  end
end
