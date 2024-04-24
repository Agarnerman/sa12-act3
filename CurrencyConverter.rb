require 'httparty'

class CurrencyConverter
  include HTTParty
  base_uri 'https://v6.exchangerate-api.com/v6/4225eb1612a2181238aee9dc/latest'

  def initialize(api_key)
    @api_key = api_key
  end

  def exchange_rate(source_currency, target_currency)
    response = self.class.get("/#{source_currency}")
    if response.success?
      exchange_data = response.parsed_response
      return exchange_data['conversion_rates'][target_currency]
    else
      raise "Error fetching exchange rate: #{response.code} - #{response.message}"
    end
  end

  def convert_amount(amount, source_currency, target_currency)
    rate = exchange_rate(source_currency, target_currency)
    converted_amount = amount * rate
    return converted_amount
  end
end

api_key = '4225eb1612a2181238aee9dc'
converter = CurrencyConverter.new(api_key)
amount = 100
source_currency = 'USD'
target_currency = 'EUR'
converted_amount = converter.convert_amount(amount, source_currency, target_currency)
puts "#{amount} #{source_currency} equals #{converted_amount.round(2)} #{target_currency}"
