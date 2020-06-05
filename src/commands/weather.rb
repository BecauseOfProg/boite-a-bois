require_relative 'command'

module BoiteABois
  module Commands
    class Weather < Command
      CATEGORY = 'weather'
      USAGE = 'weather <location>'
      DESC = 'Obtenir la météo à un endroit précis'

      def self.exec(args, context)
        begin
          data = $core.weather_api.current(args[0])
          embed = BoiteABois::Utils::embed(
            title: "#{data.city.name} :flag_#{data.city.country.downcase}:",
            thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: data.weather_conditions.icon),
            description:
              "**￶￶￶#{data.weather_conditions.description.capitalize}**\n\n" +
              ":thermometer: Température : #{data.weather_conditions.temperature}°C\n" +
              ":droplet: Humidité : #{data.weather_conditions.humidity}%\n" +
              ":cloud: Nuages : #{data.weather_conditions.clouds}%\n" +
              ":dash: Vent : #{(data.weather_conditions.wind[:speed] * 3.6).ceil(1)} km/h\n"
          )
          context.send_embed('', embed)
        rescue OpenWeatherMap::Exceptions::UnknownLocation
          context.send(':satellite_orbital: :x: Cette localisation est inconnue.')
        end
      end
    end
  end
end
