GitGrepView = require './git-grep-view'
GitGrepDialogView = require './git-grep-dialog-view'
{exec} = require 'child_process'
path = require 'path'

class Line
  constructor: ({@line, @filePath, @content, @raw}) ->

module.exports =
  gitGrepView: null
  activate: (state) ->
    atom.workspaceView.command "git-grep:grep", => @grep(state)

  grep: (state) ->
    @gitGrepView ?= new GitGrepView(state.GitGrepViewState)
    if @gitGrepView.hasParent()
      @gitGrepView.detach()
    else
      @dialog = new GitGrepDialogView
        rootPath: atom.project.rootDirectory.path
        onConfirm: (query) =>
          @_grep query, (lines) =>
            @gitGrepView.show()
            atom.workspaceView.append(@gitGrepView)
            @gitGrepView.setItems(lines)
            @gitGrepView.focusFilterEditor()
      @dialog.attach()

  deactivate: ->
    @gitGrepView?.remove()

  serialize: ->
    gitGrepViewState: @gitGrepView.serialize()

  parseGitGrep: (stdout)->
    for line in stdout.split('\n') when line.length > 5
      [filePath, content] = line.split /\:\d+\:/
      at = parseInt(line.match(/\:\d+\:/)[0][1..line.length-2], 10)
      new Line {filePath, line:at, content, raw: line}

  _grep: (query, callback) ->
    command = "git grep -n --no-color #{query}"
    exec command, {cwd: atom.project.rootDirectory.path}, (err, stdout, stderr) =>
      if err
        return callback []

      if stderr
        throw stderr if stderr
      lines = @parseGitGrep(stdout)
      callback lines
