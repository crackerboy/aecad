require! '../schema': {Schema}

export do
    1: ->
        open-collector =
            # open collector output
            iface: "Input, Output, gnd"
            bom:
                NPN: 'Q1'
                "SMD1206": "R1"
            netlist:
                Input: 'R1.1'
                2: 'Q1.b' # R1.2
                gnd: 'Q1.e'
                Output: 'Q1.c'

        sch = new Schema {name: 'test', data: open-collector, prefix: 'test.'}

        expect (-> sch.compile!)
        .to-throw "Unterminated pads: test.R1.2"

        # cleanup canvas
        sch.remove-footprints!

    "in sub-circuit": ->
        open-collector =
            # open collector output
            iface: "Input, Output, gnd"
            bom:
                NPN: 'Q1'
                "SMD1206": "R1"
            netlist:
                1: "Q1.b R1.1"
                in: "R1.2"
                gnd: "Q1.e"
                out: "Q1.c"

        some-parent =
            schemas: {open-collector}
            netlist:
                1: "A.in"
            bom:
                open-collector: 'A'


        sch = new Schema {name: 'test', data: some-parent, prefix: 'test.'}

        expect (-> sch.compile!)
        .to-throw "Unterminated pads: test.A.Input,test.A.Output,test.A.gnd"

        # cleanup canvas
        sch.remove-footprints!
