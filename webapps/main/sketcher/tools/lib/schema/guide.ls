# deps
require! './lib': {combinations}
require! 'prelude-ls': {reverse}

export do
    guide-for: (ref) ->
        guides = []
        for pads in @netlist
            for index til pads.length - 1
                line =
                    pads[index]
                    pads[index+1]

                if ref
                    unless ref.pin in line.map (.pin)
                        # unrelated pads, skip
                        continue
                    if line.1.g-pos.isClose ref.g-pos, 1
                        # correct the direction
                        line = reverse line
                guides.push @create-guide ...line
        return guides

    guide-all: ->
        @guide-for!

    create-guide: (pad1, pad2, _opts={}) ->
        opts = {+selected} <<< _opts
        #console.log "Created guide for #{pad1.uname} -> #{pad2.uname}"
        return new @scope.Path.Line do
            from: pad1.g-pos
            to: pad2.g-pos
            stroke-color: 'lime'
            stroke-width: 0.1
            selected: opts.selected
            data: {+guide}

    clear-guides: ->
        for @scope.project.layers
            for ..getItems {-recursive} when ..data.guide
                ..remove!
