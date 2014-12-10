# ftra, frot, fmul, fmvt and MPI_4 are simple shortcuts:
# - frta: function for translate
# - frot: function for rotation
# - fmvt: function for move then apply another transformation
# - fmul: function for multiplying transformations
# - MPI_4: π/4 for 90°
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
    # 1) Ensure that the scene is in front and turn around the Z axis by 90°
    tr1 = fmvt (ftra 0, 0, 1000), (frot 0, 0, MPI_4)
    # 2) Get the step1 transform and turn around the X axis by 135°
    tr2 = fmul (frot 1.5*MPI_4, 0, 0), tr1
    # 3) Get the step2 transform and use its new axis to put the scene down.
    tr3 = fmul tr2, (ftra 0, 0, -100)
    trans_scene = [tr1, tr2, tr3]
    # The complete scene is always available as the an entry in the
    # dictionary of shapes. Its name is always 'scene'.
    allSmod.scene.setTransform trans, mdtrans for trans in trans_scene
    # In famo.us, delay on animation isn't available out of the box (at least,
    # for the time being... I'm preparing something for that ☺ Stay tune).
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

# Add this scene to the router
Router.route '/', 'scene1main'
