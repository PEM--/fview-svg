Package.describe({
  name: 'pierreeric:fview-svg',
  summary: 'Encapsulate SVG in Surface, a plugin for famous-views, the Meteor bridge to famo.us.',
  version: '0.1.0',
  git: 'https://github.com/PEM--/fview-svg.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('mjn:famous@0.3.1_2', 'client', { weak: true });
  api.use('raix:famono@0.9.23', { weak: true });
  api.use([
    'gadicohen:famous-views@0.1.29',
    'coffeescript',
    'blaze',
    'templating',
    'tracker',
    'underscore'
    ], 'client');
  api.addFiles('fview-svg.coffee', 'client');
  api.export('FviewSvg', 'client');
});
