# ftra, frot, fmut and MPI_4... are simple shortcuts.
# See client/0_start/start.coffee for details.

# We start by waiting for the Meteor template to be rendered on the screen.
Template.scene1main.rendered = ->
  # Once the template is rendered, we get a reference on the fview-svg.
  svg = (FView.byId 'scene1main').view
  # fview-svg needs at least one rendering engine cycle to get ready.
  svg.ready ->
    # Now that everything is available in the DOM and famo.us virtual DOM,
    # we can play with it. Here we are getting a dictionnary of StateModifiers.
    # This is the core of the animation capability.
    allSmod = svg.getStateModifiers()
    # In this example, our animations will use the same properties and timing.
    mdtrans = curve: Easing.outElastic, duration: 1000
    # The complete scene is going to be set using 3 animations steps.
    trans_scene = [
      frot 0, 0, MPI_4
      frot 1.5*MPI_4, 0, MPI_4
      fmut (frot 1.5*MPI_4, 0, MPI_4), (ftra 0, 0, -100)
    ]
    # The complete scene is always available as the an entry in the
    # dictionary of shapes. Its name is always 'scene'.
    allSmod.scene.setTransform trans, mdtrans for trans in trans_scene
    # In famo.us delay on animation isn't done out of the box (at least, for
    # the time being... I'm preparing something for that ;-) Stay tune).
    # Thus, we are using a basic famo.us's setTimeout as it is synchronized
    # with famo.us's rendering engine.
    Timer.setTimeout ->
      # All shapes are going to be elevated to show the layout.
      for shape in shapes=['menu', 'buttons', 'logo', 'text']
        # Accessing the shapes is achieved via a dictionnary.
        allSmod[shape].setTransform (ftra 0, 0, 100), mdtrans, ->
          # As the buttons are included in the menu, we elevate them
          # a bit further once the former animation has been done.
          allSmod.buttons.setTransform (ftra 0, 0, 150), mdtrans
    , mdtrans.duration * trans_scene.length
