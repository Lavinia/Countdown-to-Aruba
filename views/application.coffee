DAY = 24 * 60 * 60 * 1000
DEPARTURE_DATE = new Date(Date.UTC(2012, 11, 17, 23))
DATE_UPDATE_INTERVAL = 30 * 1000            # Every thirty secondes

BACKGROUND_UPDATE_INTERVAL = 60 * 1000      # Every minute

WEATHER_UPDATE_INTERVAL = 30 * 60 * 1000    # Every thirty minutes

NEWS_FEED_UPDATE_INTERVAL = 60 * 60 * 1000  # Every hour
NEWS_FEED_URL = 'http://aruba-daily.com/newspaper/?feed=rss2'
NEWS_FEED_CONVERTER_URL = '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q='

STATE_COMPLETE = 4
HTTP_OK = 200
HTTP_NOT_MODIFIED = 304

days_to_departure = ->
  today = new Date
  Math.ceil((DEPARTURE_DATE.getTime() - today.getTime()) / DAY)

update_countdown = ->
  document.getElementById("countdown").innerHTML = days_to_departure()

# TODO: Visualize error messages.
update_weather = ->
  req = new XMLHttpRequest()

  req.addEventListener "readystatechange", ->
    if req.readyState is STATE_COMPLETE
      if req.status is HTTP_OK
        document.getElementById("weather").innerHTML = req.responseText
      else if req.status is HTTP_NOT_MODIFIED
        # Do nothing, weather not changed.
      else
        console.log "[#{new Date}] Could not fetch current weather."

  req.open "GET", "weather", false
  req.send()

day_time = ->
  now = new Date
  window.sun_times.sunrise.getTime() <= now.getTime() < window.sun_times.sunset.getTime()

update_background_image = ->
  if day_time()
    document.getElementById("content").style.backgroundImage = 'url("images/day.jpg")'
  else
    document.getElementById("content").style.backgroundImage = 'url("images/night.jpg")'

window.onload = ->
  update_background_image()
  setInterval(update_countdown, DATE_UPDATE_INTERVAL)
  setInterval(update_weather, WEATHER_UPDATE_INTERVAL)
  setInterval(update_background_image, BACKGROUND_UPDATE_INTERVAL)

