Router = require 'lib/router'

State = require 'models/State'

Requests = require 'collections/Requests'
TasksActive = require 'collections/TasksActive'
TasksScheduled = require 'collections/TasksScheduled'

class Application

    initialize: =>
        @views = {}
        @collections = {}

        # Get users, projects, and targets, and user settings
        # before actually starting the app
        @fetchResources =>

            $('.page-loader.fixed').hide()

            @router = new Router

            Backbone.history.start
                pushState: false
                root: '/singularity/'

            Object.freeze? @

    fetchResources: (success) =>
        @resolve_countdown = 0

        resolve = =>
            @resolve_countdown -= 1
            success() if @resolve_countdown is 0

        @resolve_countdown += 1
        @state = new State
        @state.fetch
            error: => vex.dialog.alert('An error occurred while trying to load the Singularity state.')
            success: -> resolve()

        resources = [{
            collection_key: 'requests'
            collection: Requests
            error_phrase: 'requests'
        }, {
            collection_key: 'tasksActive'
            collection: TasksActive
            error_phrase: 'active tasks'
        }, {
            collection_key: 'tasksScheduled'
            collection: TasksScheduled
            error_phrase: 'scheduled tasks'
        }]

        _.each resources, (r) =>
            @resolve_countdown += 1
            @collections[r.collection_key] = new r.collection
            @collections[r.collection_key].fetch
                error: -> vex.dialog.alert("An error occurred while trying to load Singularity #{ r.error_phrase }.")
                success: -> resolve()

module.exports = new Application