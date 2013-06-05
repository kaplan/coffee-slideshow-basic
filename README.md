Basic Slideshow with Controls
=============================

Basic slideshow, no frameworks, fading with controls. You should be able to go click crazy on the next and previous buttons, with the slideshow paused or playing and things should not break.

You can [see the example][1] in action.

Modernizr is used for detecting Javascript, but I need to workout the what happens to the slideshow when there's it's not available.

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
