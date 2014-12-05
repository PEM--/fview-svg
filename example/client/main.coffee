# Create stylesheets
niceFont = 'Lato, Helvetica Neue, Helvetica, Arial, sans-serif'
css = new CSSC
css
.add 'body',
  backgroundColor: CSSC.darkgray
.add '.title',
  paddingTop: CSSC.px 20
  fontWeight: 300
  webkitFontSmoothing: 'antialiased'
  fontFamily: niceFont
  fontSize: CSSC.px 36
  textAlign: 'center'
  color: CSSC.silver

# Set FView logging at its bare minimum
Logger.setLevel 'famous-views', 'info'

# Polyfills are necessary if you are using raix:famono
famous.polyfills

Engine = null
StateModifier = null
Surface = null
Timer = null

class Svg extends famous.core.View
  DEFAULT_OPTIONS:
    shapes: []
  constructor: (@_options) ->
    super @_options
    @id = famous.core.Entity.register @
    #console.log 'Svg.options', @_options
    #console.log Template[@_options.template]
    html = Blaze.toHTML Template[@_options.template]
    @$svg = $ html
    #console.log 'HTML', html
    smod = new StateModifier
      align: [.5,.5]
      origin: [.5,.5]
    sceneSurf = new Surface
      content: @$svg[0]
    (@add smod).add sceneSurf
    @$shapes = []
    famous.utilities.Timer.setTimeout =>
      @getAllShapes @shapesReady
    , 100
  getAllShapes: (cb) =>
    idx = @$shapes.length
    $shape = @$svg.find "##{@_options.shapes[idx]}"
    rect = $shape[0].getBoundingClientRect()
    #console.log '$logo', rect
    if rect.width is 0
      return famous.core.Engine.nextTick => @getAllShapes cb
    @$shapes.push $shape
    idx++
    if idx is @_options.shapes.length
      return cb()
    famous.core.Engine.nextTick => @getAllShapes cb
  shapesReady: =>
    console.log 'Shapes ready', @$shapes
    @modifiers = []
    @surfaces = []
    mainrect = @$svg[0].getBoundingClientRect()
    console.log 'Main rect', mainrect
    for shape in @$shapes
      rect = shape[0].getBoundingClientRect()
      mod = new StateModifier
        align: [.5,.5]
        origin: [.5,.5]
        size: [rect.width, rect.height]
      $innerSvg = $ "<svg \
        width='100%', height='100%' \
        viewBox='0 0 #{rect.width} #{rect.height}', \
        preserveAspectRatio='xMidYMid meet'>\
        </svg>"
      shape.get
      $innerSvg.append shape.clone()
      console.log 'innerSvg', $innerSvg
      surf = new Surface
        content: $innerSvg[0]
      console.log $innerSvg[0]
      @modifiers.push mod
      @surfaces.push surf
      (@add mod).add surf
      shape.remove()

FView.ready ->
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: #{niceFont}; -webkit-font-smoothing: antialiased;"
  Engine = famous.core.Engine
  StateModifier = famous.modifiers.StateModifier
  Surface = famous.core.Surface
  Timer = famous.utilities.Timer
  FView.registerView 'Svg', Svg
