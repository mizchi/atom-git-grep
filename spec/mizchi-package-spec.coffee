{WorkspaceView} = require 'atom'
MizchiPackage = require '../lib/mizchi-package'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MizchiPackage", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('mizchi-package')

  describe "when the mizchi-package:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.mizchi-package')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'mizchi-package:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.mizchi-package')).toExist()
        atom.workspaceView.trigger 'mizchi-package:toggle'
        expect(atom.workspaceView.find('.mizchi-package')).not.toExist()
