# get the date
exports.run = (event) ->
  if event.when
    d = new Date event.when
  else
    d = new Date

  [dd, m, d, y] = [d.getDay(), d.getMonth(), d.getDate(), d.getFullYear()]

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

  # return the event
  what: "core.query.response"
  data: "#{dd}, #{m} #{d}, #{y}"
