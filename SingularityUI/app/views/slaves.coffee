View = require './view'

Slave = require '../models/Slave'

class SlavesView extends View

    template: require '../templates/slaves/base'

    events: =>
        _.extend super,
            'click [data-action="remove"]': 'removeSlave'
            'click [data-action="decommission"]': 'decommissionSlave'

    render: ->
        @$el.html @template()

        @$('#active').html         @subviews.activeSlaves.$el
        @$('#dead').html           @subviews.deadSlaves.$el
        @$('#decomissioning').html @subviews.decomissioningSlaves.$el

    decommissionSlave: (event) =>
        $target = $(event.currentTarget)

        slaveModel = new Slave id: $target.data 'slave-id'
        slaveModel.promptDecommission => @trigger 'refreshrequest'

    removeSlave: (event) =>
        $target = $(event.currentTarget)

        slaveModel = new Slave
            id: $target.data 'slave-id'
            state: $target.data 'state'
        slaveModel.promptRemove => @trigger 'refreshrequest'
            

module.exports = SlavesView
