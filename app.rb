require "sinatra"
require "sinatra/reloader" if development?
require "coffee-script"
require "v8"
require "haml"
require "yahoo_weatherman"

ARUBA_WOEID = 23424736
DEPARTURE_DATE = Time.new(2012, 12, 18, 0, 0, 0, "+01:00")
SECONDS_PER_DAY = 86400
ARUBA_TIMEZONE_OFFSET = 4 * 3600

get '/' do
  calculate_days_to_departure
  weather_on_aruba do |weather|
    fetch_current_weather_info(weather)
    fetch_sun_times(weather)
  end
  haml :countdown
end

get '/application.js' do
  coffee :application
end

get '/weather' do
  fetch_current_weather_info(weather_on_aruba)
  haml :weather
end

private

def calculate_days_to_departure
  time_remaining = DEPARTURE_DATE - Time.now
  @days_to_departure = (time_remaining / SECONDS_PER_DAY).ceil
end

def weather_on_aruba
  client = Weatherman::Client.new
  weather = client.lookup_by_woeid ARUBA_WOEID

  if block_given?
    yield weather
  else
    weather
  end
end

def fetch_current_weather_info(weather)
  @image = weather.description_image.values.first
  @forecast_low = weather.forecasts.first['low']
  @forecast_high = weather.forecasts.first['high']
  @current_temperature = weather.condition['temp']
  @current_condition = weather.condition['text']
end

def fetch_sun_times(weather)
  sun_info = weather.astronomy.map {|e| e}
  local_sunrise = sun_info.first.last
  local_sunset = sun_info.last.last
  @sunrise = local_aruba_to_utc(local_sunrise)
  @sunset = local_aruba_to_utc(local_sunset)
  @cat = Time.now.to_i
end

def local_aruba_to_utc(time)
  Time.parse("#{time} UTC") + ARUBA_TIMEZONE_OFFSET
end
