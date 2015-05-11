# core.setting.where.weather.general
# respond with the current weather at the specified location
request = require "request"
_ = require "underscore"

# return the weather forecast info for an area.
exports.get_forecast = (date, utils, cb) ->
  API_KEY = utils.config.keys.wunderground

  # get local weather stations for latitude/longitude coords
  request
    method: "get"
    url: "http://api.wunderground.com/api/#{API_KEY}/geolookup/q/43.2014437,-76.2812308.json"
  , (err, resp, body) ->
    body = JSON.parse body
    if typeof body is "object"
      stations = body.location.nearby_weather_stations.pws.station
      if stations.length
        station = stations[0]

        # make sure we have a date available
        if date
          date = new Date(date)
        else
          date = new Date

        # make sure date is valid
        if date.toString() is "Invalid Date"
          cb name: "error.date.invalid"
          return

        # are we looking for weather recently?
        if (
          (
            utils.date.isDateInFuture(date) or
            utils.date.isDateToday(date)
          ) and
          utils.date.isDateWithinDays date, 2
        )

          # now, get the current weather at that station.
          request
            method: "get"
            url: "http://api.wunderground.com/api/#{API_KEY}/hourly/q/pws:#{station.id}.json"
          , (err, resp, body) ->
            body = JSON.parse body
            if typeof body is "object"

              # find all dates that match the date specified in the query
              sp = body.hourly_forecast.map (f) ->
                d = new Date parseInt(f.FCTTIME.epoch+"000")

                if date.getDate() is d.getDate() and date.getMonth() is d.getMonth() and date.getYear() is d.getYear()
                  d.getHours() - date.getHours()
                else
                  Infinity

              match = body.hourly_forecast[sp.indexOf _.min(sp)]
              cb null, match

        # date is in the past
        else
          cb
            name: "error.date.invalid"
            desc: "date is in the past."


exports.run = (event, utils, cb) ->
  exports.get_forecast event.when, utils, (err, forecast) ->
    if err
      cb data: err
    else
      cb data: forecast
