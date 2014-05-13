{$, EditorView, View} = require 'atom'

module.exports =
class GitGrepDialog extends View
  @content: (params) ->
    @div class: 'git-grep-dialog overlay from-top', =>
      @label "git grep: #{params.rootPath}"
      @subview 'miniEditor', new EditorView(mini: true)

  initialize: ({@onConfirm}) ->
    @on 'core:confirm', =>
      @onConfirm(@miniEditor.getText())
      @close()

    @on 'core:cancel', => @cancel()
    @miniEditor.hiddenInput.on 'focusout', => @close()

  attach: ->
    @miniEditor.setText('')
    atom.workspaceView.append(this)
    @miniEditor.focus()

  close: ->
    @hide()
    @remove()
    atom.workspaceView.focus()

  cancel: ->
    @hide()
