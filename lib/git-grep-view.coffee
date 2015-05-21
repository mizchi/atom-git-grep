{$$, View, SelectListView} = require 'atom-space-pen-views'
{Point} = require 'atom'
path = require 'path'

module.exports =
class GitGrepView extends SelectListView
  getFilterKey: -> 'filePath'

  initialize: (serializeState) ->
    super
    @addClass('git-grep overlay from-top')

  viewForItem: (line) ->
    """<li>
      #{line.filePath}
      :
      <span class='text-info'>L#{line.line}</span>
      /
      <span class='text-info'>L#{line.rootPath}</span>
      <br/>
      <span class='text-subtle'>#{line.content}</span>
    </li>"""

  confirmed: (item) ->
    @openPath (path.join atom.project.rootDirectories[0].path, item.filePath), item.line-1
    @hide()

  serialize: ->

  openPath: (filePath, lineNumber) ->
    if filePath
      atom.workspace.open(filePath).done => @moveToLine(lineNumber)

  moveToLine: (lineNumber=-1) ->
    return unless lineNumber >= 0
    if editor = atom.workspace.getActiveTextEditor()
      position = new Point(lineNumber)
      editor.scrollToBufferPosition(position, center: true)
      editor.setCursorBufferPosition(position)
      editor.moveToFirstCharacterOfLine()

  destroy: ->
    @detach()
