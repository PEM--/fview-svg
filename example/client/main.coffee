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
Timer = null
Easing = null

FView.ready ->
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: #{niceFont}; -webkit-font-smoothing: antialiased;"
  famous.core.Engine.nextTick -> FView.mainCtx.setPerspective 20000
  Transform = famous.core.Transform
  Timer = famous.utilities.Timer
  Easing = famous.transitions.Easing

Template.svgScene1.rendered = ->
  svg = (FView.byId 'scene').view
  svg.ready ->
    allSmod = svg.getStateModifiers()
    MPI_4 = Math.PI/4
    ftra = Transform.translate
    frot = Transform.rotate
    mdtrans =
      curve: Easing.outElastic
      duration: 1000
    trans_scene = [
      frot 0, 0, MPI_4
      frot 1.5*MPI_4, 0, MPI_4
      Transform.multiply (frot 1.5*MPI_4, 0, MPI_4), (ftra 0, 0, -100)
    ]
    for trans in trans_scene
      allSmod.scene.setTransform trans, mdtrans
    Timer.setTimeout ->
      for shape in shapes=['menu', 'buttons', 'logo', 'text']
        allSmod[shape].setTransform (ftra 0, 0, 100), mdtrans, ->
          allSmod.buttons.setTransform (ftra 0, 0, 150), mdtrans
    , mdtrans.duration * trans_scene.length
