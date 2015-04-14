request = require 'request'

module.exports =
    activate: ->
        self = this
        atom.commands.add 'atom-workspace', "snap-switch:push", => @push()
        #window.on 'beforeunload', =>
        #  @onExit = true
        atom.workspace.observePanes (pane) =>
            pane.onDidRemoveItem =>
                @push()
            pane.onDidAddItem =>
                @push()
        #console.log 'activated'

    push: ->
        self = this
        list = @names()
        try
            request.post
                uri: 'http://localhost:8080/tabs'
                json:
                    processId: process.pid
                    tabCount: list.length
                    tabTitles: list
        catch e
            # ignore
        #console.log 'pushed'

    names: ->
        panes = atom.workspace.getPanes()
        result = []
        for pane, i1 in panes
            for item, i2 in pane.getItems()
                result.push item.getTitle()
        result
