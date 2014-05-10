{WorkspaceView} = require 'atom'
GitGrep = require '../lib/git-grep'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "GitGrep", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('git-grep')

  describe "when the git-grep:grep event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.git-grep')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'git-grep:grep'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.git-grep')).toExist()
        atom.workspaceView.trigger 'git-grep:grep'
        expect(atom.workspaceView.find('.git-grep')).not.toExist()
