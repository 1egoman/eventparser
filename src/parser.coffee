requireDir = require "require-dir"
all = requireDir "./response", recurse: true

# utilities for each module
utils =

  # config files
  config: requireDir "../config"

  date:

    # format a date
    formatDate: (date) ->
      [dd, m, d, y] = [date.getDay(), date.getMonth(), date.getDate(), date.getFullYear()]

      # retreive day
      dd = [
        "sunday"
        "monday"
        "tuesday"
        "wednesday"
        "thursday"
        "friday"
        "saturday"
      ][dd]

      # retreive month
      m = [
        "january"
        "febuary"
        "march"
        "april"
        "may"
        "june"
        "july"
        "august"
        "september"
        "october"
        "november"
        "december"
      ][m]

      "#{dd}, #{m} #{d}, #{y}"

    formatTime: (time) ->
      [h, m] = [time.getHours(), time.getMinutes()]

      # am or pm
      if h < 12
        ap = "AM"
      else
        ap = "PM"

      # format hours
      h -= 12 while h > 12

      # format minutes, too
      m = "0#{m}" if m < 10

      "#{h}:#{m} #{ap}"

    formatDateTime: (dt) ->
      "#{@formatDate dt} at #{@formatTime dt}"

    # =========== #
    # COMPARISONS #
    # =========== #

    # is a specified date today?
    isDateToday: (date) ->
      today = new Date
      date.getDate() is today.getDate() and
      date.getMonth() is today.getMonth() and
      date.getYear() is today.getYear()

    # check to see if a date is in the week
    isDateThisWeek: (date) ->
      today = new Date
      date.getMonth() is today.getMonth() and
      date.getYear() is today.getYear() and
      date.getDate() < today.getDate()+7 and
      date.getDate() > today.getDate()-7

    # is a date within a specified number of days on either side
    isDateWithinDays: (date, days) ->
      oneDay = 1000 * 60 * 60 * 24

      now = new Date
      start = new Date now.getFullYear(), 0, 0
      diff = now - start
      nowdate = diff / oneDay

      start = new Date date.getFullYear(), 0, 0
      diff = now - start
      basedate = diff / oneDay

      basedate > nowdate-days and basedate < nowdate+days


    isDateInFuture: (date) ->
      today = new Date
      date.getTime() > today.getTime()

    isDateInPast: (date) ->
      today = new Date
      date.getTime() < today.getTime()



module.exports = (event, callback) ->

  # format and call the callback
  respond = (out) ->
    out.name = event.what
    out.id = event.id
    callback null, out

  # check for malformed event
  if event and event.what

    # go to the correct package name
    head = all
    for cursor in event.what.split '.'
      if head[cursor]
        head = head[cursor]
      else
        respond
          name: "error.event.nonexistant"
          data: "No such response exists: #{event.what} (failed on #{cursor})"
        break

    head = head.index if not head.run

    # run the module, passing in the event and a callback
    # a module can run synchronously and return from itself,
    # or can work asynchronously and use the provided callback.
    if head
      r = head.run event, utils, respond
      respond r if r.what

  else
    respond
      name: "error.event.malformed"
