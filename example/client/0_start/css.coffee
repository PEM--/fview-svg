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
