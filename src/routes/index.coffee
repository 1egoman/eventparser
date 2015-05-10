express = require "express"
app = express.Router()
parser = require "../parser"

module.exports = ->

  app.get "/", (req, res) ->
    res.render "index"


  # accept a new event, and start the parsing process
  app.post "/event/accept/:namespace?", (req, res) ->
    event = req.body

    parser event, (err, out) ->
      res.send out



  app
