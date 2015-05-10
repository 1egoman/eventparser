# core.system.status
# respond with the status of the system
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "100% up and running!"
