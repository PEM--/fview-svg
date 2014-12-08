Package.describe({
  name: 'pierreeric:fview-svg',
  summary: 'Encapsulate SVG in Surface, a plugin for famous-views, the Meteor bridge to famo.us.',
  version: '0.1.3',
  git: 'https://github.com/PEM--/fview-svg.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('mjn:famous', 'client', { weak: true });
  api.use('raix:famono', { weak: true });
  api.use([
    'gadicohen:famous-views',
    'coffeescript',
    'blaze',
    'templating',
    'tracker',
    'underscore'
    ], 'client');
  api.addFiles('fview-svg.coffee', 'client');
  api.export('FviewSvg', 'client');
});
