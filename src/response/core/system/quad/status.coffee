# core.system.quad.status
# how are the quads doing, currently?
exports.run = (event, utils, cb) ->
  cb
    what: "core.query.response"
    data: "quads are currently non-functional"
