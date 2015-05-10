# get the time
exports.run = (event) ->
  if event.when
    d = new Date event.when
  else
    d = new Date

  [h, m] = [d.getHours(), d.getMinutes()]

  # am or pm
  if h < 12
    ap = "AM"
  else
    ap = "PM"

  # format hours
  h -= 12 while h > 12

  # format minutes, too
  m = "0#{m}" if m < 10

  # return the event
  what: "core.query.response"
  data: "#{h}:#{m} #{ap}"
