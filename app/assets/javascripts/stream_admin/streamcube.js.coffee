#= require d3
#= require cubism

window.StreamCube = class StreamCube
    DefaultOptions:
        el: "#foo"
        
    constructor: (opts) ->
        @options = _.defaults opts, @DefaultOptions
        
        @context = cubism.context().serverDelay(10).step(6e4).size(1030)
        
        console.log "setting up cube server at #{@options.server}"
        @cube = @context.cube( @options.server )
        
        #@horizon = @context.horizon().metric @cube.metric
        
        @metrics = [
            "sum(stream_minutes(duration))"
        ]
        
        @el = $ @options.el
        
        console.log "el is ", @el
        
        # Add top and bottom axes to display the time.
        @d3 = d3.select(@options.el)
                
        @d3.selectAll(".axis")
            .data(["top", "bottom"])
            .enter().append("div")
            .attr("class", ((d) => "#{d} axis"))
            .each (d) -> d3.select(this).call(_this.context.axis().ticks(12).orient(d))
            
        # Add a mouseover rule.
        @d3.append("div")
            .attr("class", "rule")
            .call(@context.rule())
            
        metrics = [
            "sum(stream_minutes(duration))",
            "sum(stream_minutes(duration).re(ua,\"KPCC\"))"
        ]
        
        i = 0
            
        @d3.insert("div",".bottom")
            .attr("class", "group")
            .call( -> @append("header").text("Average Listeners") )
            .selectAll(".horizon")
            .data(["All Listeners","KPCC App Listeners"])
            .enter().append("div")
            .attr("class","horizon")
            .call(@context.horizon().format( d3.format(".0f") ).height(100).metric((d) => @cube.metric(metrics[i++]).divide(60)))
            
        # On mousemove, reposition the chart values to match the rule.
        @context.on "focus", (i) => 
            d3.selectAll(".value").style("right", if i == null then null else @context.size() - i + "px")
                            
        #@d3.call(@horizon)