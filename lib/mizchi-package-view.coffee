{View} = require 'atom'

module.exports =
class MizchiPackageView extends View
  @content: ->
    @div class: 'mizchi-package overlay from-top', =>
      @div "The MizchiPackage package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "mizchi-package:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "MizchiPackageView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
