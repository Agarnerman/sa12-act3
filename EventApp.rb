require 'net/http'
require 'json'

def get_events(api_key, location)
  uri = URI("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&city=#{location}")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def display_events(events_data)
  events = events_data['_embedded']['events']
  events.each do |event|
    name = event['name']
    venue = event['_embedded']['venues'][0]['name']
    date = event['dates']['start']['localDate']
    time = event['dates']['start']['localTime']
    
    puts "Event: #{name}"
    puts "Venue: #{venue}"
    puts "Date: #{date}"
    puts "Time: #{time}"
    puts "---------------------"
  end
end

api_key = '7hdFgmbVkcoig03vZzmggRHBepYwzd7d'
location = 'Memphis'
events_data = get_events(api_key, location)
if events_data['_embedded'] && events_data['_embedded']['events'].any?
    puts "Events in #{location}:"
    display_events(events_data)
else
    puts "No events found in #{location}."
end
