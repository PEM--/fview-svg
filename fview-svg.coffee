FView.ready ->
  # fview-svg is a famous's view component.
  # fviw-svg relies on Blaze, the Meteor templating engine.
  class FviewSvg extends famous.core.View
    @DEFAULT_OPTIONS:
      shapes: []
      stroke: 0
    constructor: (@options) ->
      super @options
      @id = famous.core.Entity.register @
      html = Blaze.toHTML Template[@options.template]
      @$svg = $ html
      $svgtag = @$svg.find 'rect'
      @smod = new famous.modifiers.StateModifier
        align: [.5,.5]
        origin: [.5,.5]
      @sceneSurf = new famous.core.Surface
        content: @$svg[0]
      @sceneSurf.on 'resize', =>
        # TODO ensure responsive behavior
        console.log 'Resizing', @sceneSurf.getSize()
      @scenenode = @add @smod
      @scenenode.add @sceneSurf
      @$shapes = []
      # Need at least one cycle for the SVG to get ready and rendered
      famous.core.Engine.nextTick => @getAllShapes @shapesReady
    getAllShapes: (cb) =>
      idx = @$shapes.length
      $shape = @$svg.find "##{@options.shapes[idx]}"
      rect = $shape[0].getBoundingClientRect()
      if rect.width is 0
        return famous.core.Engine.nextTick => @getAllShapes cb
      @$shapes.push $shape
      idx++
      if idx is @options.shapes.length
        return cb()
      famous.core.Engine.nextTick => @getAllShapes cb
    shapesReady: =>
      @modifiers = []
      @surfaces = []
      mainrect = @$svg[0].getBoundingClientRect()
      ratio = mainrect.width / @$svg[0].viewBox.baseVal.width
      for shape in @$shapes
        famousrect = shape[0].getBoundingClientRect()
        svgrect = shape[0].getBBox()
        mod = new famous.modifiers.StateModifier
          align: [0,0]
          origin: [0,0]
          size: [
              famousrect.width + @options.stroke
              famousrect.height + @options.stroke
            ]
          transform: famous.core.Transform.translate \
            svgrect.x*ratio, \
            svgrect.y*ratio, \
            0
        $innerSvg = $ "<svg \
          width='100%', height='100%' \
          viewBox='\
            #{svgrect.x - @options.stroke/2} \
            #{svgrect.y - @options.stroke/2} \
            #{svgrect.width + @options.stroke} \
            #{svgrect.height + @options.stroke}', \
          preserveAspectRatio='xMidYMid meet'>\
          </svg>"
        shape.get
        $innerSvg.append shape.clone()
        surf = new famous.core.Surface
          content: $innerSvg[0]
        @modifiers.push mod
        @surfaces.push surf
        (@scenenode.add mod).add surf
        shape.remove()
  # Register the component
  FView.registerView 'FviewSvg', FviewSvg
