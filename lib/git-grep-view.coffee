{View} = require 'atom'
{SelectListView} = require 'atom'
path = require 'path'
{$$, Point, SelectListView} = require 'atom'

module.exports =
class GitGrepView extends SelectListView
  getFilterKey: -> 'filePath'

  initialize: (serializeState) ->
    super
    @addClass('git-grep overlay from-top')

  viewForItem: (line) ->
    """<li>
      <span class='path'>#{line.filePath}</span>
      :
      <span class='line-number'>L#{line.line}</span>
      :
      <span class='content'>#{line.content}</span>
    </li>"""

  confirmed: (item) ->
    @openPath (path.join atom.project.rootDirectory.path, item.filePath), item.line-1
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
