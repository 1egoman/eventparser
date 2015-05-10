requireDir = require "require-dir"
all = requireDir "./response", recurse: true

module.exports = (event, callback) ->

  # format and call the callback
  respond = (out) ->
    out.id = event.id
    console.log out
    if "error" in out.what
      callback out
    else
      callback null, out

  # go to the correct package name
  head = all
  for cursor in event.what.split '.'
    if head[cursor]
      head = head[cursor]
    else
      respond
        what: "core.query.error"
        data: "No such response exists: #{event.what} (failed on #{cursor})"
      break

  head = head.index if not head.run

  # run the module, passing in the event and a callback
  # a module can run synchronously and return from itself,
  # or can work asynchronously and use the provided callback.
  if head
    r = head.run event, respond
    respond r if r.what
