module BoiteABois
  # Different utilities for the whole app
  module Utils
    # Generate a Discord embed
    #
    # @param title [String] Embed's title
    # @param description [String] Text to display in the embed
    # @param url [String] URL the user can click on
    # @param author [Discordrb::Webhooks::EmbedAuthor] Embed's author
    # @param thumbnail [Discordrb::Webhooks::EmbedThumbnail] Little image to display on the side
    # @param image [Discordrb::Webhooks::EmbedImage] Big image to display on top of the embed
    # @param timestamp [Time] Embed's time
    # @param footer [Discordrb::Webhooks::EmbedFooter] Embed's footer
    # @param fields [Array<Discordrb::Webhooks::EmbedField>] Embed's fields, with title and value
    def Utils.embed(title: nil,
                    description: nil,
                    url: nil,
                    author: nil,
                    thumbnail: nil,
                    image: nil,
                    timestamp: Time.now,
                    footer: Discordrb::Webhooks::EmbedFooter.new(
                      text: "#{$config['name']} v#{$config['version']}",
                      icon_url: $config['illustration']
                    ),
                    fields: [])
      Discordrb::Webhooks::Embed.new(
        title: title,
        color: $config['color'].to_i,
        description: description,
        url: url,
        fields: fields,
        author: author,
        thumbnail: thumbnail,
        image: image,
        timestamp: timestamp,
        footer: footer
      )
    end
  end
end