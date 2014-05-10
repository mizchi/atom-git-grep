MizchiPackageView = require './mizchi-package-view'
{EditorView} = require 'atom'

class InputView extends EditorView
  initialize: ->
    super

module.exports =
  mizchiPackageView: null
  activate: (state) ->
    atom.workspaceView.command "mizchi-package:toggle", => @toggle(state)

  toggle: (state) ->
    @view ?= new MizchiPackageView(state.mizchiPackageViewState)
    if @view.hasParent()
      @view.detach()
    else
      atom.workspaceView.append(@view)
      @view.show()
      @view.startGrep()
      @view.focusFilterEditor()

  deactivate: ->
    @mizchiPackageView.destroy()

  serialize: ->
    mizchiPackageViewState: @mizchiPackageView.serialize()
