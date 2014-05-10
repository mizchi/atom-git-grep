MizchiPackageView = require './mizchi-package-view'

module.exports =
  mizchiPackageView: null

  activate: (state) ->
    @mizchiPackageView = new MizchiPackageView(state.mizchiPackageViewState)

  deactivate: ->
    @mizchiPackageView.destroy()

  serialize: ->
    mizchiPackageViewState: @mizchiPackageView.serialize()
