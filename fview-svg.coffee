FView.ready ->
  # fview-svg is a famous's view component.
  # fviw-svg relies on Blaze, the Meteor templating engine.
  class FviewSvg extends famous.core.View
    @DEFAULT_OPTIONS:
      shapes: []
      template: undefined
      stroke: 0
      zOrderStart: 0
    constructor: (@options) ->
      super @options
      unless @options.template?
        return FView.log.error 'fview-svg: You must specify a template.'
      @id = famous.core.Entity.register @
      tpl = Template[@options.template]
      unless tpl?
        return FView.log.error "fview-svg: Cannot find template named \
          '#{@options.template}'."
      html = Blaze.toHTML tpl
      @_$svg = $ html
      @_isReady = false
      @_readyQueue = []
      @_readyDep = new Tracker.Dependency
      @_createSvg()
    _createSvg: ->
      @_nodes = []
      @_curzOrder = @options.zOrderStart
      outerMod = new famous.modifiers.StateModifier
      @_nodes.push outerMod
      innerMod = new famous.modifiers.StateModifier
        align: [.5,.5]
        origin: [.5,.5]
        tranform: famous.core.Transform.translate 0,0, @_curzOrder++
      @_sceneSurf = new famous.core.Surface
        content: @_$svg[0]
      @_initialSceneSize = undefined
      @_sceneSurf.on 'resize', =>
        # TODO ensure responsive behavior
        curSize = @_sceneSurf.getSize()
        if @_initialSceneSize is undefined
          @_initialSceneSize = famous.utilities.Utility.clone curSize
        console.log 'Resizing', @_initialSceneSize, curSize
      @_scenenode = (@add outerMod).add innerMod
      @_scenenode.add @_sceneSurf
      @_$shapes = []
      # Need at least one cycle for the SVG to get ready and rendered
      famous.core.Engine.nextTick => @_getAllShapes @_shapesReady
    _getAllShapes: (cb) =>
      idx = @_$shapes.length
      $shape = @_$svg.find "##{@options.shapes[idx]}"
      rect = $shape[0].getBoundingClientRect()
      if rect.width is 0
        return famous.core.Engine.nextTick => @_getAllShapes cb
      @_$shapes.push $shape
      idx++
      if idx is @options.shapes.length
        return cb()
      famous.core.Engine.nextTick => @_getAllShapes cb
    _shapesReady: =>
      mainrect = @_$svg[0].getBoundingClientRect()
      ratio = mainrect.width / @_$svg[0].viewBox.baseVal.width
      for shape in @_$shapes
        famousrect = shape[0].getBoundingClientRect()
        svgrect = shape[0].getBBox()
        outerMod = new famous.modifiers.StateModifier
        innerMod = new famous.modifiers.StateModifier
          align: [0,0]
          origin: [0,0]
          size: [
              famousrect.width + @options.stroke
              famousrect.height + @options.stroke
            ]
          transform: famous.core.Transform.translate \
            svgrect.x*ratio, \
            svgrect.y*ratio, \
            @_curzOrder++
        $innerSvg = $ "<svg \
          width='100%', height='100%' \
          viewBox='\
            #{svgrect.x - @options.stroke/2} \
            #{svgrect.y - @options.stroke/2} \
            #{svgrect.width + @options.stroke} \
            #{svgrect.height + @options.stroke}', \
          preserveAspectRatio='xMidYMid meet'>\
          </svg>"
        $innerSvg.append shape.clone()
        surf = new famous.core.Surface
          content: $innerSvg[0]
        ((@_scenenode.add outerMod).add innerMod).add surf
        @_nodes.push outerMod
        shape.remove()
      @_runReadies()
    getSize: -> @_sceneSurf.getSize()
    ready: (cb) =>
      if cb
        if @_isReady
          cb()
        else
          @_readyQueue.push cb
      else
        @_readyDep.depend()
        @_isReady
    _runReadies: ->
      @_isReady = true
      @_readyDep.changed()
      (@_readyQueue.shift())() while @_readyQueue.length
    getStateModifiers: ->
      _.extend (scene: @_nodes[0]), \
        (_.object @options.shapes, \
          (@_nodes[idx] for idx in [1...@_nodes.length]))

  # Register the component
  FView.registerView 'FviewSvg', FviewSvg
