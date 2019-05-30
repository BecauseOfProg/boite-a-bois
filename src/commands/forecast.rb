require_relative 'command'

module BoiteABois
  module Commands
    class Forecast < Command

      CATEGORY = 'weather'
      USAGE = 'forecast <location>'
      DESC = 'Obtenir les prévisions météo sur 5 jours d\'un endroit précis'
      CHANNELS = [556896893481779205]

      def self.exec(args, context)
        begin
          data = $core.weather_api.forecast(args[0])
          context.send("￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ #{data.city.name} :flag_#{data.city.country.downcase}: - Prévisions")
          data.forecast.each do |condition|
            next unless condition.time.hour % 2 == 0
            context.send("￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ **#{condition.time.day}/#{condition.time.month} à #{condition.time.hour}h**
  ￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶ ￶￶#{condition.emoji} #{condition.description.capitalize}

:thermometer: Température : #{condition.temperature}°C
:droplet: Humidité : #{condition.humidity}%
:cloud: Nuages : #{condition.clouds}%
:dash: Vent : #{(condition.wind[:speed] * 3.6).ceil(1)} km/h")
          end
        rescue OpenWeatherMap::Exceptions::UnknownLocation
          context.send(':satellite_orbital: :x: Cette localisation est inconnue.')
        end
      end

    end
  end
end