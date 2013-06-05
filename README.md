Basic Slideshow with Controls
=============================

Basic slideshow, no frameworks, fading with controls. You should be able to go click crazy on the next and previous buttons, with the slideshow paused or playing and things should not break.

It's just a super basic slideshow where I'm trying to learn. Seems like a good starting point.

Modernizr is used for detecting Javascript, but I need to workout the what happens to the slideshow when there is no Javascript.

You can [see the example][1] in action.

Basic setup and usage
---------------------
STUDIO is the namespaced module using a handful of Private methods and properties. Then there are a few Public methods that are returned and used in the index.html file.

If you wanted to play around with it, there are really only a few moving parts in the front. The index.html file has a slideshow-wrapper with divs that I think of as 'slides'. These divs can contain text, image, be links.

The studio.slideshow.js is loaded at the bottom of the page.
`<script src="javascripts/studio.slideshow.js"></script>`

Then when the page loads, you could use jQuery's ready but I'm just putting the script at the bottom of body before the closing tag, a call to the makeSlideshow.intiSlides method within the module is made (think that's how you refer to it... a module). That will take all the divs within the slideshow-wrapper and start everyting going.
`STUDIO.makeSlideshow.initSlides("slideshow-wrapper");`

The controls, which I'm playing around with .innerHTML to set in the Coffeescript/Javascript, handle the play/pause, next and previous like this:

    <div id="toggleSlideshow" onclick="STUDIO.makeSlideshow.pauseSlideshow()"> &#9787; Play / Pause &#9785;</div>
    <div id="nextSlide" onclick="STUDIO.makeSlideshow.nextSlide()">blah ✎ </div>
    <div id="prevSlide" onclick="STUDIO.makeSlideshow.prevSlide()"></div>

That's the Public API I think
-----------------------------
* initSlides
* pauseSlideshow
* nextSlide
* prevSlide


More Details
------------
I left all of my comments and notes to myself in the .coffee file. I find myself going back to earlier versions of this slideshow and building on top or modifiying. My goal here was to develop a nice base file that would help me learn more about using [Coffeescript][2].

[js2Coffee.org][3] was a big help for looking at my older version of plain Javascript and moving over to a Coffeescript version.

There's a Rake file that starts watching on the .coffee and the .scss files if you do `rake` from the directory in the Terminal. The rake file comes from a Nick Quaranto post on using [Jekyll, SCSS and Coffeescript without plugins][4].

> I'm usually wrong the first few times and that's okay. &#9787;
> Love to hear what you think.

Goals
-----
* This version: make it progressively enhanced or degrade nicely.
* Next version: Add thumbnail images
* Future version: Add jQuery and Greesock Animation Library

[1]: http://workalicious.com/dev/slideshows/coffee-slideshow-basic/
[2]: http://coffeescript.org/
[3]: http://js2coffee.org/
[4]: http://quaran.to/blog/2013/01/09/use-jekyll-scss-coffeescript-without-plugins/
