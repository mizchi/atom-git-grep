GitGrepView = require './git-grep-view'
GitGrepDialogView = require './git-grep-dialog-view'
{exec} = require 'child_process'
path = require 'path'
flatten = require 'lodash.flatten'
{CompositeDisposable} = require 'atom'

class Line
  constructor: ({@line, @filePath, @content, @raw}) ->

module.exports =
  gitGrepView: null
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'git-grep:grep': => @grep(state)

  grep: (state) ->
    @gitGrepView ?= new GitGrepView(state.GitGrepViewState)
    if @gitGrepView.hasParent()
      @gitGrepView.detach()
    else
      rootPaths = atom.project.rootDirectories.map (root) -> root.path
      rootPath = rootPaths[0]

      @dialog = new GitGrepDialogView
        rootPaths: rootPaths
        onConfirm: (query) =>
          Promise.all(
            rootPaths.map (rootPath) => @_grep(rootPath, query)
          ).then (chunks) =>
            lines = flatten chunks
            @gitGrepView.show()
            @gitGrepView.appendTo(atom.views.getView(atom.workspace))
            @gitGrepView.setItems(lines)
            @gitGrepView.focusFilterEditor()
      @dialog.attach()

  deactivate: ->
    @gitGrepView?.remove()
    @subscriptions?.dispose()

  serialize: ->
    gitGrepViewState: @gitGrepView.serialize()

  parseGitGrep: (stdout) ->
    for line in stdout.split('\n') when line.length > 5
      [filePath, content] = line.split /\:\d+\:/
      at = parseInt(line.match(/\:\d+\:/)[0][1..line.length-2], 10)
      new Line {filePath, rootPath: null, line: at, content, raw: line}

  _grep: (rootPath, query) -> new Promise (done, reject) =>
    command = "git grep -n --no-color #{query}"
    exec command, {cwd: rootPath}, (err, stdout, stderr) =>
      if err then return done [] # no item
      if stderr then return reject(stderr)
      lines = @parseGitGrep(stdout).map (line) ->
        line.rootPath = rootPath
        line
      done(lines)
