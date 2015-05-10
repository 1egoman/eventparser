# core.setting.where.weather.precip
# respond with the current precipitation at the specified location
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "It may be raining."
