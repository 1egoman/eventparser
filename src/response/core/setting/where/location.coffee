# core.setting.where.location
# respond with the current location of the user
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "X marks the spot."
