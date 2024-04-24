require 'httparty'
require 'json'

class WeatherDataAggregator
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_current_weather(city)
    response = self.class.get("/weather?q=#{city}&appid=#{@api_key}&units=metric")
    if response.success?
      return JSON.parse(response.body)
    else
      raise "Failed to fetch weather data: #{response.code} - #{response.message}"
    end
  end

  def fetch_hourly_forecast(city)
    response = self.class.get("/forecast?q=#{city}&appid=#{@api_key}&units=metric")
    if response.success?
      return JSON.parse(response.body)
    else
      raise "Failed to fetch forecast data: #{response.code} - #{response.message}"
    end
  end

  def average_temperature(city, hours = 24)
    forecast_data = fetch_hourly_forecast(city)
    temperatures = forecast_data['list'].first(hours).map { |entry| entry['main']['temp'] }
    total_temperature = temperatures.inject(0.0) { |sum, temp| sum + temp }
    average_temp = total_temperature / temperatures.length
    return average_temp.round(2)
  end
end

api_key = '840daf8a50f23095954f23388fb15cdb'
weather_aggregator = WeatherDataAggregator.new(api_key)
city = 'New York' 
puts "Fetching weather data for #{city}..."
current_weather = weather_aggregator.fetch_current_weather(city)
puts "Current temperature in #{city}: #{current_weather['main']['temp']}°C"
puts "Average temperature in #{city} over the next 24 hours: #{weather_aggregator.average_temperature(city)}°C"
