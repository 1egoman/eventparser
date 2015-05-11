# core.user.notify.later
# remind the user of something at a later date
exports.run = (event, utils, cb) ->
  time = event.when or new Date
  cb data: "On #{utils.date.formatDateTime time.ref}, I will remind you to #{event.label}"
