# fview-svg
Encapsulate SVG in Surface, a plugin for famous-views, the Meteor bridge to famo.us.

:warning: Work in progress :warning:

## Advantages
* Better minification: SVG transformed into HTML.js ~20% less bandwidth consumed.
* Live in JS space, can be cloned easily.
* Transported with your single minified JS, no additional round trip time for getting the image.
* Instant availability when the application starts.
* DOM patching via DOM range when assets are changed.

## References
* [Remove all transforms in SVG] (http://stackoverflow.com/questions/13329125/removing-transforms-in-svg-files)
* [SVGO](https://github.com/svg/svgo)
* [HTML2Jade](http://html2jade.org/)
