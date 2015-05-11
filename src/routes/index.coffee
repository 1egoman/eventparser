express = require "express"
app = express.Router()
parser = require "../parser"

module.exports = ->

  app.get "/", (req, res) ->
    res.render "index"


  # accept a new event, and start the parsing process
  app.post "/event/accept/:namespace?", (req, res) ->
    event = req.body

    # make sure type is valid
    if event.name is "core.event.nlp_decoded"
      parser event, (err, out) ->
        res.send out
    else
      res.send
        name: "error.event.type.invalid"
        desc: "Invalid type for event: `#{event.type}`"



  app
