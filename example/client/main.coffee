# Create stylesheets
niceFont = 'Lato, Helvetica Neue, Helvetica, Arial, sans-serif'
css = new CSSC
css
.add 'body',
  backgroundColor: CSSC.darkgray
.add '.title',
  fontWeight: 300
  webkitFontSmoothing: 'antialiased'
  fontFamily: niceFont
  fontSize: CSSC.px 30
  textAlign: 'center'
  color: CSSC.silver

# Set FView logging at its bare minimum
Logger.setLevel 'famous-views', 'info'

# Polyfills are necessary if you are using raix:famono
famous.polyfills

Engine = null
StateModifier = null
Surface = null

class Svg extends famous.core.View
  DEFAULT_OPTIONS:
    shapes: []
  constructor: (_options) ->
    super _options
    @id = famous.core.Entity.register @
    console.log 'Svg.options', _options
    console.log Template[_options.template]
    html = Blaze.toHTML Template[_options.template]
    $svg = $ html
    $logo = $svg.find "##{_options.shapes[0]}"
    console.log 'logo', $logo
    #console.log 'HTML', html
    smod = new StateModifier
      align: [.5,.5]
      origin: [.5,.5]
    sceneSurf = new Surface
      content: html
    (@add smod).add sceneSurf

FView.ready ->
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: #{niceFont}; -webkit-font-smoothing: antialiased;"
  Engine = famous.core.Engine
  StateModifier = famous.modifiers.StateModifier
  Surface = famous.core.Surface
  FView.attrEvalAllowedKeys = ['transform']
  FView.registerView 'Svg', Svg
