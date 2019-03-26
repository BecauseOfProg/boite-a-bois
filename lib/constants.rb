module BoiteABois
  module Constants
    # The weather API object to use for some commands
    WEATHER_API = OpenWeatherMap::API.new '81e865545c1eb880fec091006c869b9d', 'fr', 'metric'
  end
end