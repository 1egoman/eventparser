express = require "express"
app = express.Router()
parser = require "../parser"
events = require "../events"
async = require "async"
fs = require "fs"
path = require "path"

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


              get_config: (prop_name, cb) ->
                fs.readFile path.join("config", "config.json"), (err, data) ->
                  if err
                    cb err
                  else
                    cb null, JSON.parse(data)[prop_name]

              get_config_many: (props_names, cb) ->
                async.map props_names, @get_config, cb



      else
        res.send
          name: "error.event.type.invalid"
          data: "Invalid type for event: `#{event.type}`"



  app
