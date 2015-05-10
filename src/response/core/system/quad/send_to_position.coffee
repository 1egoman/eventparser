request = require "request"

# core.system.quad.send_to_position
# send a quad to my current position
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "sending quad..."
