GitGrepView = require './git-grep-view'
{EditorView} = require 'atom'

module.exports =
  gitGrepView: null
  activate: (state) ->
    atom.workspaceView.command "git-grep:grep", => @grep(state)

  grep: (state) ->
    @view ?= new GitGrepView(state.GitGrepViewState)
    if @view.hasParent()
      @view.detach()
    else
      atom.workspaceView.append(@view)
      @view.show()
      @view.startGrep()
      @view.focusFilterEditor()

  deactivate: ->
    @gitGrepView.destroy()

  serialize: ->
    gitGrepViewState: @gitGrepView.serialize()
