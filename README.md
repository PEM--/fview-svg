# fview-svg
Encapsulate SVG in Surface, a plugin for famous-views, the Meteor bridge to famo.us.

:warning: Work in progress :warning:

This plugin uses SVG as Meteor templates. By parsing the SVG, it encapsulates the part of the SVG that you want to animate into famo.us  `StateModifier` and `Surfaces`. This delivers hardware accelerated performance to SVG.

## Preparing your assets
### Aspect ratio
When creating the template that will contain your SVG, you need to:
* Remove any width or height.
* Specify the viewBox with its value X and Y set to 0.
* Ensure the preservation of the aspect ratio using `preserveAspectRatio='xMinYMin meet'`.

**Example**
```jade
svg(viewBox='0 0 400 300', preserveAspectRatio='xMinYMin meet')
```

### SVG transformations
You should better stay off SVG transformations (translate, rotate, ...). They are not hardware accelerated. See references hereafter for detailed solutions on how to remove SVG transformations when using [Inkscape](http://inkscape.org/).

## Advantages
* Better minification: Using Blaze, SVG are transformed into HTML.js. On the wire, the SVG consumes ~20% less bandwidth.
* Your SVG lives in JS space. They can be cloned easily.
* As they are transported with your single minified JS, Meteor's default behavior, there is no additional round trip time for getting your SVG.
* Your SVG are instantaneously available when your application starts.
* Insertion of your SVG in the DOM is achieved via DOM range when assets are changed, as a default Meteor behavior.

## References
* [Remove all transforms in SVG] (http://stackoverflow.com/questions/13329125/removing-transforms-in-svg-files)
* [SVGO](https://github.com/svg/svgo)
* [HTML2Jade](http://html2jade.org/)
