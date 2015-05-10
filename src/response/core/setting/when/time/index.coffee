# get the time
exports.run = (event, utils) ->
  if event.when
    d = new Date event.when
  else
    d = new Date

  # return the event
  what: "core.query.response"
  data: utils.formatTime d
