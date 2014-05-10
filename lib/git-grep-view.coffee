{View} = require 'atom'
{exec} = require 'child_process'
{SelectListView} = require 'atom'
path = require 'path'
{$$, Point, SelectListView} = require 'atom'

class Line
  constructor: ({@line, @filePath, @content}) ->

module.exports =
class GitGrepView extends SelectListView

  initialize: (serializeState) ->
    super
    @minQuerySize = 3 # TODO: inject params as setting
    @addClass('git-grep overlay from-top')

    @filterEditorView.getEditor().getBuffer().on 'changed', =>
      query = @filterEditorView.getEditor().getText()
      if query.length >= @minQuerySize
        @startGrep(query)
      true

  viewForItem: (line) ->
    """<li>
      <span style="color:white">#{line.filePath}</span>
      :
      <span style="color:linen">L#{line.line}</span>
      :
      <span style="color:grey">#{line.content}</span>
    </li>"""

  confirmed: (item) ->
    @openPath (path.join atom.project.rootDirectory.path, item.filePath), item.line
    @hide()

  serialize: ->

  openPath: (filePath, lineNumber) ->
    if filePath
      atom.workspaceView.open(filePath).done => @moveToLine(lineNumber)

  moveToLine: (lineNumber=-1) ->
    return unless lineNumber >= 0
    if editorView = atom.workspaceView.getActiveView()
      position = new Point(lineNumber)
      editorView.scrollToBufferPosition(position, center: true)
      editorView.editor.setCursorBufferPosition(position)
      editorView.editor.moveCursorToFirstCharacterOfLine()

  destroy: ->
    @detach()

  getFilterKey: -> 'filePath'

  startGrep: (query = '') ->
    console.log 'start grep, query', query
    @setItems([])
    exec "git grep -n #{query}", {cwd: atom.project.rootDirectory.path}, (err, stdout, stderr) =>
      lines = stdout.split('\n').map (line) =>
        [filePath, line, content] = line.replace(/(\:| \\\:)/g, "$sp$").split("$sp$")
        new Line {filePath, line, content}
      @setItems lines.filter (line) => line.filePath
