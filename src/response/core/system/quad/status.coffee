# core.system.quad.status
# how are the wuads doing, currently?
exports.run = (event, cb) ->
  cb
    what: "core.query.response"
    data: "quads are currently non-functional"
