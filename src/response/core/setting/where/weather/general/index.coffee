# core.setting.where.weather.general
# respond with the current weather at the specified location
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "Well, the weather exists. That's a start!"
