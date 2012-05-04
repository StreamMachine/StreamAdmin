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
        
        @all = @cube.metric("sum(stream_minutes(duration))").divide(60)
        @yesterday = @all.shift(-1 * 24 * 60 * 60 * 1000)
        @kpcc = @cube.metric("sum(stream_minutes(duration).re(ua,\"KPCC\"))").divide(60)
        @chrome = @cube.metric("sum(stream_minutes(duration).re(ua,\"Chrome\"))").divide(60)
        @safari = @cube.metric("sum(stream_minutes(duration).re(ua,\"Safari\"))").divide(60)
        @firefox = @cube.metric("sum(stream_minutes(duration).re(ua,\"Firefox\"))").divide(60)
        @msie = @cube.metric("sum(stream_minutes(duration).re(ua,\"MSIE\"))").divide(60)

            
        @metrics = [
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @all),
            @context.comparison().primary(@all).secondary(@yesterday).height(150).scale( d3.scale.pow().exponent(.5) ),
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @kpcc)
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @chrome)
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @firefox)
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @safari)
            @context.horizon().format( d3.format(".0f") ).height(150).metric( (d) => @msie)
        ]
        
        i = 0
            
        @d3.insert("div",".bottom")
            .attr("class", "group")
            .call( -> @append("header").text("Average Listeners") )
            .selectAll(".horizon")
            .data(["All Listeners","Compared to Yesterday","KPCC App Listeners","Chrome Listeners","Firefox","Safari","Internet Explorer"])
            .enter().append("div")
            .attr("class","horizon")
            .call (sel) => sel.each (d,i) -> _this.metrics[i](d3.select(this))
            
        # On mousemove, reposition the chart values to match the rule.
        @context.on "focus", (i) => 
            @d3.selectAll(".value").style("right", if i == null then null else @context.size() - i + "px")
                            
        #@d3.call(@horizon)