{$, TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class GitGrepDialog extends View
  @content: (params) ->
    path = params.rootPaths.join(' / ')
    @div class: 'git-grep-dialog overlay from-top', =>
      @label "git grep: #{path}"
      @subview 'miniEditor', new TextEditorView(mini: true)

  initialize: ({@onConfirm}) ->
    atom.commands.add @element,
      'core:confirm': =>
        @onConfirm(@miniEditor.getText())
        @close()
      'core:cancel': =>
        @cancel()

    @miniEditor.on 'focusout', => @close()

  attach: ->
    @miniEditor.setText('')
    atom.views.getView(atom.workspace).appendChild(@element)
    @miniEditor.focus()

  close: ->
    @hide()
    @remove()
    #$(atom.views.getView(atom.workspace)).focus()

  cancel: ->
    @hide()
