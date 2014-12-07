Template.scene1main.rendered = ->
  svg = (FView.byId 'scene1main').view
  svg.ready ->
    allSmod = svg.getStateModifiers()
    mdtrans = curve: Easing.outElastic, duration: 1000
    trans_scene = [
      frot 0, 0, MPI_4
      frot 1.5*MPI_4, 0, MPI_4
      fmut (frot 1.5*MPI_4, 0, MPI_4), (ftra 0, 0, -100)
    ]
    allSmod.scene.setTransform trans, mdtrans for trans in trans_scene
    Timer.setTimeout ->
      for shape in shapes=['menu', 'buttons', 'logo', 'text']
        allSmod[shape].setTransform (ftra 0, 0, 100), mdtrans, ->
          allSmod.buttons.setTransform (ftra 0, 0, 150), mdtrans
    , mdtrans.duration * trans_scene.length
