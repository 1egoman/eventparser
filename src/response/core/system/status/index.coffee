# core.system.status
# respond with the status of the system
exports.run = (event, utils, cb) ->
  # TODO possibly run the test suite and see if anything is flagged?
  cb data: "100% up and running!"
