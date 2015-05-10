requireDir = require "require-dir"
all = requireDir "./response", recurse: true

# utilities for each module
utils =

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

module.exports = (event, callback) ->

  # format and call the callback
  respond = (out) ->
    out.id = event.id
    console.log out
    if "error" in out.what
      callback out
    else
      callback null, out

  # go to the correct package name
  head = all
  for cursor in event.what.split '.'
    if head[cursor]
      head = head[cursor]
    else
      respond
        what: "core.query.error"
        data: "No such response exists: #{event.what} (failed on #{cursor})"
      break

  head = head.index if not head.run

  # run the module, passing in the event and a callback
  # a module can run synchronously and return from itself,
  # or can work asynchronously and use the provided callback.
  if head
    r = head.run event, utils, respond
    respond r if r.what
