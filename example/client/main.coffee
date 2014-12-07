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

Transform = null

FView.ready ->
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: #{niceFont}; -webkit-font-smoothing: antialiased;"
  famous.core.Engine.nextTick -> FView.mainCtx.setPerspective 2000
  Transform = famous.core.Transform

Template.svgScene1.rendered = ->
  svg = (FView.byId 'scene').view
  svg.ready ->
    allSmod = svg.getStateModifiers()
    allSmod.scene.setAlign [.5,.5]
    allSmod.scene.setOrigin [.5,.5]
    allSmod.scene.setTransform (Transform.rotateZ Math.PI/4), duration: 500
