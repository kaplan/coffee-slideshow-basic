// Generated by CoffeeScript 1.6.2
/*

Slideshow Application
========================================================================================================

Description:  Basic slideshow, no frameworks, fading with controls. You can go click crazy on the next and previous, with the slideshow paused or playing and things should not (hmmm) break.

Neat stuff: There is also a Rake file you can run in the Terminal to start the watch on the scss and coffeescript. I'm not sure what the last parts are, I should find out more. The Rake comes from a great post, by Nick Quaranto: http://quaran.to/blog/2013/01/09/use-jekyll-scss-coffeescript-without-plugins/

Dependencies: Modernizr, for js detection

Version:      1.0
Created:      2013-06-02
Last Mod:     2013-06-04

Notes: Originally devloped for crkarch.com's responsive non-Flash site version, then development continued on versions  for Le Bernardin, which used JS only, then refined for Kerrygold where I used Greensock to animate a sliding effect for the images. Earlier versions used clearInterval with setTimeouts, which was totally wrong. I think these are right now.

Because I'm new to Coffeescript the top chunk has a Module Pattern done in Coffeescript as reference with Private and Public Methods and Properties. It's a classic: http://www.yuiblog.com/blog/2007/06/12/module-pattern/

And a little modulus example b/c my mind always forgets how that works.

This version also has lots of comments, but the nice thing about compiled Coffeescript is that fact it leaves em out.

The goal for this version was to move to coffeescript and not use any frameworks. Eventually, the next version will move to jQuery for traversing and selecting and Greensock for animating.

The addLoadEvent function is in here to use instead of jQuery's ready and to load multiple functions in a specific order ( I think that's what it's primary purpose is? Putting scripts at the bottom before the closing body does the DOM ready thing I think? )

The next version is going to have thumbnails for navigating between the slides.

========================================================================================================
*/

var addLoadEvent, _ref;

addLoadEvent = function(func) {
  var oldonload;

  oldonload = window.onload;
  if (typeof window.onload !== 'function') {
    return window.onload = func;
  } else {
    return window.onload = function() {
      oldonload();
      return func();
    };
  }
};

this.STUDIO = (_ref = this.STUDIO) != null ? _ref : {};

this.STUDIO.makeSlideshow = (function() {
  var curImage, fadeInContainer, fadeInContainerTimeout, fadeOutSlide, fadeOutSlideAdvance, fadeOutTimeout, loadedSlideCount, next, onImageLoad, photos, playback, prev, reorderLayerStack, runSlideshow, setOpacity, setVisibilityForAdvance, slideCount, slides, slideshow, slideshowPaused, slideshowTimeout, totalImageCount;

  slideshow = slides = photos = playback = next = prev = "unknown";
  fadeInContainerTimeout = slideshowTimeout = fadeOutTimeout = null;
  curImage = slideCount = totalImageCount = loadedSlideCount = 0;
  slideshowPaused = false;
  onImageLoad = function(slideOrder) {
    slides[slideOrder].style.display = "block";
    loadedSlideCount++;
    console.log("loading an image " + slideOrder);
    console.log("loadedSlideCount is " + loadedSlideCount);
    console.log("======================");
    if (totalImageCount === loadedSlideCount) {
      console.log("+ ================== +");
      console.log("+ ALL IMAGES LOADED! +");
      console.log("+ ================== +");
      return fadeInContainerTimeout = setTimeout(function() {
        console.log("!! ALL IMAGES LOADED: FADE IN THE SLIDESHOW CONTAINER !!");
        return fadeInContainer(slideshow, 0, 500);
      });
    }
  };
  setOpacity = function(obj, opacity) {
    obj.style.filter = "alpha(opacity:" + opacity + ")";
    obj.style.KHTMLOpacity = opacity / 100;
    obj.style.MozOpacity = opacity / 100;
    obj.style.opacity = opacity / 100;
    return obj.style.opacity = opacity / 100;
  };
  fadeInContainer = function(obj, opacity) {
    var fadeInTimeout;

    if (opacity <= 100) {
      setOpacity(obj, opacity);
      opacity += 2;
      return fadeInTimeout = setTimeout(function() {
        return fadeInContainer(obj, opacity, 200);
      });
    } else {
      console.log("+++ fadeInContainer complete +++");
      clearTimeout(fadeInTimeout);
      clearTimeout(fadeInContainerTimeout);
      return slideshowTimeout = setTimeout(function() {
        console.log("*** slideshow playing, first time start ***");
        runSlideshow();
        return slideshowPaused = false;
      }, 4000);
    }
  };
  runSlideshow = function() {
    console.log("+++ runSlideshow called +++");
    console.log("curImage is " + curImage);
    console.log("next image is: " + photos[(curImage + 1) % slides.length].alt);
    slides[(curImage + 1) % slides.length].style.visibility = 'visible';
    setOpacity(slides[(curImage + 1) % slides.length], 100);
    console.log("slideshowTimeout ID: " + slideshowTimeout);
    clearTimeout(slideshowTimeout);
    console.log("slideshowTimeout ID: " + slideshowTimeout);
    return fadeOutSlide(slides[curImage % slides.length], 100);
  };
  fadeOutSlide = function(obj, opacity) {
    if (opacity >= 0) {
      console.log("fade out slide " + opacity);
      setOpacity(obj, opacity);
      opacity -= 2;
      return fadeOutTimeout = setTimeout(function() {
        return fadeOutSlide(obj, opacity, 200);
      });
    } else {
      console.log("+++ fadeOutSlide complete +++");
      clearTimeout(fadeOutTimeout);
      slides[curImage % slides.length].style.visibility = 'hidden';
      reorderLayerStack();
      curImage++;
      if (curImage % slides.length === 0) {
        curImage = 0;
      }
      if (!slideshowPaused) {
        return slideshowTimeout = setTimeout(runSlideshow, 3500);
      }
    }
  };
  fadeOutSlideAdvance = function(obj, opacity, direction) {
    var shuffle, slide, _i, _len;

    if (opacity >= 0) {
      console.log("fade out slide " + opacity);
      setOpacity(obj, opacity);
      opacity -= 10;
      return fadeOutTimeout = setTimeout(function() {
        return fadeOutSlideAdvance(obj, opacity, 10);
      });
    } else {
      console.log("+++ fadeOutSlideAdvance complete for advancing slide +++");
      obj.style.visibility = 'hidden';
      if (!slideshowPaused) {
        slideshowTimeout = setTimeout(runSlideshow, 3500);
      }
      shuffle = function() {
        return slides[_i].style.zIndex = ((slides.length - _i) + (curImage - 1)) % slides.length;
      };
      for (_i = 0, _len = slides.length; _i < _len; _i++) {
        slide = slides[_i];
        shuffle(slide);
      }
      return true;
    }
  };
  setVisibilityForAdvance = function(direction) {
    console.log("+++ setVisibilityForAdvance called: slide advance direction " + direction.name + " +++");
    switch (direction) {
      case next:
        return slides[(curImage + 1) % slides.length].style.visibility = 'visible';
      case prev:
        console.log((curImage - 1) % slides.length);
        return slides[(curImage - 1) % slides.length].style.visibility = 'visible';
      default:
        break;
    }
  };
  reorderLayerStack = function() {
    var shuffle, slide, _i, _len;

    shuffle = function() {
      return slides[_i].style.zIndex = ((slides.length - _i) + curImage) % slides.length;
    };
    for (_i = 0, _len = slides.length; _i < _len; _i++) {
      slide = slides[_i];
      shuffle(slide);
    }
    return true;
  };
  return {
    initSlides: function(slideWrapper) {
      var fadeInTimeout, i, slide, _i, _len, _results;

      console.log("+++ initSlides called +++");
      curImage = 0;
      loadedSlideCount = 0;
      slideshow = document.getElementById(slideWrapper);
      slides = slideshow.getElementsByTagName("div");
      photos = slideshow.getElementsByTagName("img");
      totalImageCount = photos.length;
      next = document.getElementById("nextSlide");
      console.log(next);
      next.innerHTML = "next &#10095;";
      next.name = "NEXT";
      prev = document.getElementById("prevSlide");
      prev.innerHTML = "&#10094; prev";
      prev.name = "PREV";
      playback = document.getElementById("toggleSlideshow");
      setOpacity(slideshow, 50);
      for (_i = 0, _len = slides.length; _i < _len; _i++) {
        slide = slides[_i];
        slide.style.zIndex = (slides.length - 1) - _i;
        setOpacity(slide, 20);
        slide.style.visibility = 'hidden';
      }
      setOpacity(slides[0], 100);
      slides[0].style.visibility = 'visible';
      console.log("totalImageCount is " + totalImageCount);
      console.log("loadedSlideCount is " + loadedSlideCount);
      if (totalImageCount === loadedSlideCount) {
        console.log("+ ================== +");
        console.log("+ IMAGES WERE CACHED +");
        console.log("+ ================== +");
        return fadeInTimeout = setTimeout(function() {
          return fadeInContainer(obj, opacity, 20);
        });
      } else {
        console.log("load a slide image");
        i = 0;
        _results = [];
        while (i < totalImageCount) {
          photos[i].onLoad = onImageLoad(i);
          _results.push(i += 1);
        }
        return _results;
      }
    },
    pauseSlideshow: function() {
      if (!slideshowPaused) {
        console.log("slideshow paused");
        clearTimeout(slideshowTimeout);
        slideshowPaused = true;
        return playback.innerHTML = "Slideshow is paused, &#9787; Play it.";
      } else {
        console.log("slideshow playing");
        runSlideshow();
        slideshowPaused = false;
        return playback.innerHTML = "Slideshow is playing, &#9785; Pause it.";
      }
    },
    nextSlide: function() {
      console.log("+++ next slide button clicked +++");
      clearTimeout(slideshowTimeout);
      setVisibilityForAdvance(next);
      clearTimeout(fadeOutTimeout);
      setOpacity(slides[(curImage + 1) % slides.length], 100);
      fadeOutSlideAdvance(slides[curImage % slides.length], 100, next);
      curImage++;
      if (curImage % slides.length === 0) {
        return curImage = 0;
      }
    },
    prevSlide: function() {
      console.log("+++ prev slide button clicked +++");
      console.log("curImage is " + curImage);
      clearTimeout(slideshowTimeout);
      clearTimeout(fadeOutTimeout);
      if (curImage % slides.length === 0) {
        curImage = slides.length;
      }
      setVisibilityForAdvance(prev);
      setOpacity(slides[(curImage - 1) % slides.length], 100);
      fadeOutSlideAdvance(slides[curImage % slides.length], 100, prev);
      return curImage--;
    },
    timeoutClear: function() {
      console.log("clearing... " + slideshowTimeout);
      return clearTimeout(slideshowTimeout);
    }
  };
})();
