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
  @DEFAULT_OPTIONS:
    shapes: []
    stroke: 0
  constructor: (@options) ->
    super @options
    @id = famous.core.Entity.register @
    console.log 'Svg.options', @options
    #console.log Template[@options.template]
    html = Blaze.toHTML Template[@options.template]
    @$svg = $ html
    $svgtag = @$svg.find 'rect'
    console.log 'Viewbox', @$svg[0].viewBox.baseVal
    famous.utilities.Timer.setTimeout =>
      console.log 'Parent size', @getSize()
    , 200
    #console.log 'HTML', html
    @smod = new StateModifier
      align: [.5,.5]
      origin: [.5,.5]
    sceneSurf = new Surface
      content: @$svg[0]
    @scenenode = @add @smod
    @scenenode.add sceneSurf
    @$shapes = []
    if true
      famous.utilities.Timer.setTimeout =>
        @getAllShapes @shapesReady
      , 32
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
      mod = new StateModifier
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
      surf = new Surface
        content: $innerSvg[0]
      @modifiers.push mod
      @surfaces.push surf
      (@scenenode.add mod).add surf
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
