express = require "express"
app = express.Router()
parser = require "../parser"
events = require "../events"

pjson = require "../../package.json"


module.exports = ->

  app.get "/", (req, res) ->
    res.render "index"


  # accept a new event, and start the parsing process
  app.post "/event/accept/:namespace?", (req, res) ->
    event = req.body
    event.namespace = req.params.namespace

    # make sure type is valid
    events.can_resolve_event event.name, (resolvable) ->
      if resolvable
        events.get_event event.name, (err, evt) ->
          if err
            name: "error.couldnt.require.module"
          else
            evt.run event, do ->

              version: pjson.version

              async: ->
                (event) ->
                  res.send event

      else
        res.send
          name: "error.event.type.invalid"
          desc: "Invalid type for event: `#{event.type}`"



  app
