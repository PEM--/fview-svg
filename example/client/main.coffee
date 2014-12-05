# Create stylesheets
css = new CSSC
css
.add 'body',
  backgroundColor: CSSC.darkgray
.add '.title',
  fontFamily: 'Helvetica Neue, Arial, sans-serif'
  fontSize: CSSC.px 30
  textAlign: 'center'
  color: CSSC.silver

# Set FView logging at its bare minimum
Logger.setLevel 'famous-views', 'info'

# Polyfills are necessary if you are using raix:famono
famous.polyfills

FView.ready ->
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: 'Lato', 'Helvetica Neue', Helvetica, Arial, sans-serif; \
    -webkit-font-smoothing: antialiased;"

Template.scene.rendered = ->
  Engine = famous.core.Engine
  Engine.nextTick ->
    window.logo = ($ 'g#logo')
    console.log logo
