# core.canned.jokes
# respond with a canned joke from
request = require "request"

exports.run = (event, utils, cb) ->
  request
    method: "get"
    url: "http://api.icndb.com/jokes/random?limitTo=[nerdy]"
  , (err, resp, body) ->
    if not err and body
      p = JSON.parse body
      cb
        
        data: decodeURIComponent(p.value.joke)
