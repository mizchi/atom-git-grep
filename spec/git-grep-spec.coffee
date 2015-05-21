{WorkspaceView} = require 'atom'
GitGrep = require '../lib/git-grep'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "GitGrep", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('git-grep')

  describe "when the git-grep:grep event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(workspaceElement.querySelector('.git-grep-dialog')).not.toExist()
      atom.commands.dispatch workspaceElement, 'git-grep:grep'
      waitsForPromise ->
        activationPromise
      runs ->
        expect(workspaceElement.querySelector('.git-grep-dialog')).toExist()
