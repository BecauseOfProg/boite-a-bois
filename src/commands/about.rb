require_relative 'command'

module BoiteABois
  module Commands
    class About < Command
      CATEGORY = 'utilities'
      USAGE = 'about'
      DESC = 'Avoir des informations pratiques sur Boîte à Bois'

      def self.exec(_args, context)
        embed = BoiteABois::Utils::embed(
          title: 'À propos',
          thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: $config['illustration']),
          description:
            "Boîte à bois est un robot Discord créé par la BecauseOfProg dans le but d'avoir de nombreux utilitaires, mais surtout des jeux.\n" +
            "Son code source est ouvert à tous : n'hésitez-pas à contribuer à son développement !\n\n" +

            ":hammer: Version : #{$config['version']}\n" +
            ":globe_with_meridians: Site Internet : #{$config['website']}\n" +
            ":computer: Mainteneur : #{$config['maintainer']['name']} (#{$config['maintainer']['link']})\n\n" +

            ":copyright: 2020, BecauseOfProg. Sous licence GNU GPL v3"
        )
        context.send_embed('', embed)
      end
    end
  end
end
