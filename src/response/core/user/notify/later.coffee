# core.user.notify.later
# remind the user of something at a later date
exports.run = (event, utils, cb) ->
  time = event.when or new Date

  cb
    what: "core.query.response"
    data: "On #{utils.formatDateTime time}, I will remind you to #{event.name}"