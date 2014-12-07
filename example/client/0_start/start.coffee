# Set FView logging at its bare minimum
Logger.setLevel 'famous-views', 'info'

# Polyfills are necessary if you are using famo.us
famous.polyfills

# Namespace shortcuts
@Transform = famous.core.Transform
@Timer = famous.utilities.Timer
@Easing = famous.transitions.Easing
# Functions shortcuts
@ftra = Transform.translate
@frot = Transform.rotate
@fmult = Transform.multiply
@fmvt = Transform.moveThen
# Constants shortcuts
@MPI_4 = Math.PI/4

# Once FView is ready, display a nice message
FView.ready ->
  # Print a nice and frienly welcome message in the dev tools
  console.info "%c\nfamous-views started\n", \
    "font-weight: 300; color: #ec5f3e; font-size: x-large; \
    font-family: #{niceFont}; -webkit-font-smoothing: antialiased;"
