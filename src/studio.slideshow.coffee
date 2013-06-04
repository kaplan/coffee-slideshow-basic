###

Slideshow Application
========================================================================================================

Description:  Basic slideshow, no frameworks, fading with controls

Dependencies: Modernizr, for js detection

Version:      1.0
Created:      2013-06-02
Last Mod:     2013-06-04

Notes: Originally devloped for crkarch.com's responsive non-Flash site version, then development continued on versions  for Le Bernardin, which used JS only, then refined for Kerrygold where I used Greensock to animate a sliding effect for the images.

The goal for this version was to move to coffeescript and not use any frameworks. Eventually, the next version will move to jQuery for traversing and selecting and Greensock for animating.

The addLoadEvent function is in here to use instead of jQuery's ready and to load multiple functions in a specific order ( I think that's what it's primary purpose is? Putting scripts at the bottom before the closing body does the DOM ready thing I think? )

========================================================================================================

###

# ===============================================
# Coffeescript Module Pattern for reference

# SAMPLE COFFEE MODULE PATTERN
# Namespace the application using this with an empty object if is not null
# @STUDIO = @STUDIO ? {}

# STUDIO Module for Slideshow
# @STUDIO.sampleModulePattern = do ->

#   # Private

#   # private properties
#   myPrivateVar = "myPrivateVar accessed from within the Studio.sampleModulePattern"

#   # private methods
#   myPrivateMethod = ->
#     console.log("myPrivateMethod accessed from within the Studio.sampleModulePattern")

#   # Public

#   # using the : with the property adds a return
#   # the return opens the properties and methods public access
#   # from within the public interface you can access the private methods and properties

#   # public properties
#   myPublicProperty: "myPublicProperty is being accessed in here!"

#   # public methods
#   myPublicMethod: ->
#     console.log("<--- myPublicMethod called ---> ");
#     # Within sampleModulePattern, you can access private
#     console.log(myPrivateVar)
#     myPrivateMethod()


# MODULUS info, because you're not so good at math or remembering remainder action
# 30 % 10 = 0 -> the remainder is .0 ( 30/10 = 3.0 )
# 43 % 10 = 3 -> the remainder is .3 ( 43/10 = 4.3 )
# 1 % 4 = 1 -> the remainder is rounded to 1 from ( 1/4 = 0.25 ) ??


# Window attached instead of a namespaced module
addLoadEvent = (func) ->
  oldonload = window.onload
  if typeof window.onload isnt 'function'
    window.onload = func
  else
    window.onload = ->
      oldonload()
      func()


# ===============================================

# Namespace the application using this with an empty object if is not null
@STUDIO = @STUDIO ? {}

# ORDER OF EVENTS

# slideshow initialization
#   + hide/make sure wrapper is hidden
#   + get the photos in the wrapper
#   + load each image from a source
#   + intial fade up of wrapper when images are done
#   + start slideshow
# slideshow interaction

# onImageLoad else triggers fadeInContainer
  # fadeInContainer triggers runSlideshow
    # runSlideshow triggers fadeOutSlide
      # fadeOutSlide handles z-index and checks the state on slideshowPaused
        # if there's no pause then fadeOutSlide calls runSlideshow again

# =======
# PRIVATE
# onImageLoad called image's onLoad event happens (need to look into onload vs onLoad IE thing??)
# setOpacity called during/for all fading timeouts
# fadeInContainer calls runSlideshow, sets opacity, timeout calls itself
# runSlideshow sets opacity calls fadeout
# fadeOutSlide sets opacity, inteval calls itself, shuffles z-index
# reorderLayerStack reorders the z-index stack looping over all slides after a slide fades down

# setVisibilityForAdvance
# fadeOutSlideAdvance

# =======
# PUBLIC
# initSlides
# pauseSlideshow

# nextSlide
# prevSlide

@STUDIO.makeSlideshow = do ->

  # PRIVATE

  slideshow = slides = photos = playback = next = prev = "unknown"
  fadeInContainerTimeout = slideshowTimeout = fadeOutTimeout = null
  curImage = slideCount = totalImageCount = loadedSlideCount = 0
  slideshowPaused = false

  # FOR IMAGE LOADED COUNTING
  onImageLoad = (slideOrder) ->
    # after each imaage is loaded make sure it's display is not 'none'
    # bc in the CSS these all start display none, which hides them before they completely load in IE
    slides[slideOrder].style.display = "block";

    loadedSlideCount++
    console.log "loading an image #{slideOrder}"
    console.log "loadedSlideCount is #{loadedSlideCount}"
    console.log "======================"
    if totalImageCount is loadedSlideCount
      console.log "+ ================== +"
      console.log "+ ALL IMAGES LOADED! +"
      console.log "+ ================== +"

      #  After all the images are loaded fade up the container with: fadeInContainer()
      #  Then when the container fade up is done, start the slideshow running.
      #  Increase compatibility with unnamed functions
      fadeInContainerTimeout = setTimeout(->
        console.log "!! ALL IMAGES LOADED: FADE IN THE SLIDESHOW CONTAINER !!"
        # the 0 is what we're fading up from, 500 is a delay of .5 seconds
        fadeInContainer slideshow, 0, 500)


  # FOR ALL FADING INTERVAL CALLS
  setOpacity = (obj, opacity) ->
    # Firefox flicker fix ?
    # opacity = (opacity == 100)?99.999:opacity;

    # IE/Win
    obj.style.filter = "alpha(opacity:"+opacity+")"

    # Safari<1.2, Konqueror
    obj.style.KHTMLOpacity = opacity/100

    # Older Mozilla and Firefox
    obj.style.MozOpacity = opacity/100

    # Safari 1.2, newer Firefox and Mozilla, CSS3
    obj.style.opacity = opacity/100

    # opacity = (opacity == 100)?99.999:opacity;
    obj.style.opacity = opacity / 100


  # FOR INITAL WRAPPER FADE UP INTERVAL
  fadeInContainer = (obj, opacity) ->
    if opacity <= 100
      # console.log "fade in slide #{opacity}"
      setOpacity(obj, opacity)
      opacity += 2
      fadeInTimeout = setTimeout(->
        fadeInContainer obj, opacity, 200)
    else
      console.log "+++ fadeInContainer complete +++"
      # clear the timeout that did this fading
      clearTimeout(fadeInTimeout);

      # clear the timeout that called this method
      clearTimeout fadeInContainerTimeout

      # START the runSlideshow
      # setTimeout examples
      # slowAlert = ->
      #   console.log "That was really slow!"
      # timeoutID = window.setTimeout(slowAlert, 2000);

      # anonymous setTimeout with multiple methods or property settings,
      # you need the new line that has comma with delay amount or an error is thrown
      slideshowTimeout = setTimeout(->
        console.log  "*** slideshow playing, first time start ***"
        runSlideshow()
        slideshowPaused = false
      , 4000)

      # plain old named setTimeout, handy for a single method call with delay
      # slideshowTimeout = setTimeout(runSlideshow, 3500)

  runSlideshow = ->
    console.log "+++ runSlideshow called +++"
    console.log "curImage is #{curImage}"
    console.log "next image is: #{photos[(curImage + 1) % slides.length].alt}"

    # SETTINGS ON NEXT IMAGE IN STACK
    # make the next image in the stack visible (look in the top from some modulus info, which you always forget)
    # and that it's opaque when you fade out the current image, which will reveal the one under
    slides[(curImage + 1) % slides.length].style.visibility = 'visible'
    setOpacity(slides[(curImage + 1) % slides.length], 100)

    # clear the timeout that called this method
    console.log "slideshowTimeout ID: #{slideshowTimeout}"
    clearTimeout slideshowTimeout
    console.log "slideshowTimeout ID: #{slideshowTimeout}"

    # FADE OUT current image
    fadeOutSlide(slides[curImage % slides.length], 100)


  fadeOutSlide = (obj, opacity) ->
    if opacity >= 0
      console.log "fade out slide #{opacity}"
      setOpacity(obj, opacity)
      opacity -= 2
      fadeOutTimeout = setTimeout( ->
        fadeOutSlide obj, opacity, 200)
    else
      console.log "+++ fadeOutSlide complete +++"

      # clear the timeout used to fade the current image, just finished
      clearTimeout fadeOutTimeout

      # HIDE the current image that just had the next one faded over it
      slides[curImage % slides.length].style.visibility = 'hidden'

      # SHUFFLE INDEX
      reorderLayerStack()

      # increase the curImage
      curImage++

      # check to see if the curImage is 0, in that case we'll reset
      # if curImage % (slides.length) is 0
      #   curImage = 0
      #   console.log "*** reset curImage ***"
      # shorter still, but no logging
      curImage = 0 if curImage % slides.length is 0

      # check to see if the slideshow is paused, if not runSlideshow again
      slideshowTimeout = setTimeout(runSlideshow, 3500) unless slideshowPaused


  fadeOutSlideAdvance = (obj, opacity, direction) ->
    if opacity >= 0
      console.log "fade out slide #{opacity}"
      setOpacity(obj, opacity)
      opacity -= 10
      fadeOutTimeout = setTimeout( ->
        # note: you're looking at passing arguments in () no commas used outside of there but you need a new line
        # fadeOutSlideAdvance(obj, opacity)
        # 200)
        fadeOutSlideAdvance obj, opacity, 10)
    else
      console.log "+++ fadeOutSlideAdvance complete for advancing slide +++"
      obj.style.visibility = 'hidden'

      # call the runSlideshow so the show keeps running
      slideshowTimeout = setTimeout(runSlideshow, 3500) unless slideshowPaused

      # Reorder the layer stack
      shuffle = ->
        slides[_i].style.zIndex = ((slides.length - _i) + (curImage - 1)) % slides.length
      shuffle slide for slide in slides
      return true


  setVisibilityForAdvance = (direction) ->
    console.log "+++ setVisibilityForAdvance called: slide advance direction #{direction.name} +++"

    # check the direction to determine which 'next or prev' image should be visible
    # so that it is visible when the current image fades out.
    switch direction
      when next
        slides[(curImage + 1) % slides.length].style.visibility = 'visible'
      when prev
        console.log (curImage - 1) % slides.length
        slides[(curImage - 1) % slides.length].style.visibility = 'visible'
      else
        break


  reorderLayerStack = ->
    # console.log "+++ shuffle z-index +++"
    # console.log "+++ shuffle z-index: #{slides.length} +++"

    # Looking at for in loops in Coffeescript
    # This works great, but more approaches can be found
    # OPTION 1
    # for slide in slides
      # slides[_i].style.zIndex = (((slides.length) - _i) + curImage) % slides.length

    # Also works but hard to read, methodize the first expression with shuffle = ->
    # You can turn this into something more readable
    # OPTION 2
    # slides[_i].style.zIndex = (((slides.length) - _i) + curImage) % slides.length for slide in slides

    # Define a method and use it in the loop
    # OPTION 3 MY FAVORITE
    shuffle = ->
      slides[_i].style.zIndex = (((slides.length) - _i) + curImage) % slides.length
    shuffle slide for slide in slides
    return true

    # OR
    # OPTION 4
    # a while loop approach which is like a regular for loop
    # i = 0
    # while i < slides.length
    #   console.log i
    #   slides[i].style.zIndex = (((slides.length) - i) + curImage) % slides.length
    #   i++





  # PUBLIC

  initSlides: (slideWrapper) ->
    console.log "+++ initSlides called +++"
    curImage = 0
    loadedSlideCount = 0
    slideshow = document.getElementById(slideWrapper)
    slides = slideshow.getElementsByTagName("div")
    photos = slideshow.getElementsByTagName("img")
    totalImageCount = photos.length
    # console.log "totalImageCount = #{totalImageCount}"
    # console.log "photos = #{photos}"
    # console.log "slides = #{slides}"

    # SET THE PLAYBACK NEXT PREV UI
    # you use the name property to determine which direction the slide clicks are going
    # you have a switch set against that direction
    next = document.getElementById("nextSlide")
    console.log next
    next.innerHTML = "next &#10095;"
    next.name = "NEXT"
    prev = document.getElementById("prevSlide")
    prev.innerHTML = "&#10094; prev"
    prev.name = "PREV"
    playback = document.getElementById("toggleSlideshow")

    # FADE DOWN THE WRAPPER (50% for now)
    setOpacity(slideshow, 50)

    # SETTINGS FOR EACH SLIDE: z-index, opacity, offset position, visibility (for IE8)
    # after you do the initial settings, turn up the first slide
    for slide in slides
      # console.log slides
      # console.log photos[_i]
      # console.log "img src is  #{photos[_i].getAttribute('src')}"

      # ORDER the z-index of the slides so that the first is on top
      # console.log "======================"
      # console.log "_i is #{_i}"
      # console.log "(#{slides.length} slides - 1) - #{_i} is #{((slides.length-1)-_i)}"
      # console.log "======================"
      slide.style.zIndex = ((slides.length-1)-_i)

      # FADE DOWN EACH SLIDE (20% for now)
      setOpacity(slide, 20)

      # OFFSET the slides (useful if you were going to slide the images or hide them, except IE8 stinks!)
      # You aren't really doing this in the plain fade version,
      # If you did offset, you need to make sure you set back to 0 before the image on top fades out.
      # offsetWidth isn't working either.
      # console.log slide.offsetWidth
      # slide.style.left = "#{380}px"
      # slide.style.left = "#{slide.offsetWidth}px"
      # it seems like setting the visiblity to hidden is the only option for IE8 slide hiding
      slide.style.visibility = 'hidden';


    # SHOW and FADE UP the first slide, after you've hidden them all
    setOpacity(slides[0], 100)
    # slides[0].style.left = 0
    slides[0].style.visibility = 'visible'


    # CHECK THE LOAD STATUS
    console.log "totalImageCount is #{totalImageCount}"
    console.log "loadedSlideCount is #{loadedSlideCount}"

    if totalImageCount is loadedSlideCount
      console.log "+ ================== +"
      console.log "+ IMAGES WERE CACHED +"
      console.log "+ ================== +"

      # Fade up or show the first slide code goes here
      fadeInTimeout = setTimeout(->
        fadeInContainer obj, opacity, 20)

    # otherwise check for the total images loaded to match the total image count
    else
      console.log "load a slide image"
      i = 0
      while i < totalImageCount
        photos[i].onLoad = onImageLoad(i)
        # console.log slides[i].offsetWidth
        i += 1

    # end initSlides

  pauseSlideshow: ->
    # console.log "+++ currently slideshowPaused is #{slideshowPaused} +++"
    unless slideshowPaused
      console.log "slideshow paused"
      clearTimeout slideshowTimeout
      slideshowPaused = true
      playback.innerHTML = "&#9787; Play"
    else
      console.log "slideshow playing"
      runSlideshow()
      slideshowPaused = false
      playback.innerHTML = "Pause &#9785;"


  nextSlide: ->
    console.log "+++ next slide button clicked +++"

    # if you want to keep the slideshow playing after clicking to advance clearTimeout for calling it
    # because you call runSlideshow again with a new timeout in the complete on fadeOutSlideAdvance
    clearTimeout slideshowTimeout

    # make sure the next slide is visible before the current one fades out
    setVisibilityForAdvance(next)

    # clear any current image fade out timeouts, needed if you're quickly advancing
    # I don't think you need to worry about completing the fade b/c we set opacity and visibilty.
    clearTimeout fadeOutTimeout

    # set the opacity on the slide about to be revealed during the current image fade out
    setOpacity(slides[(curImage + 1) % slides.length], 100)

    # fade out for advancing slide
    fadeOutSlideAdvance(slides[curImage % slides.length], 100, next)

    # current image iteration
    curImage++

    # current image reset if needed
    curImage = 0 if curImage % slides.length is 0

  prevSlide: ->
    console.log "+++ prev slide button clicked +++"
    console.log "curImage is #{curImage}"

    # if you want to keep the slideshow playing after clicking to advance clearTimeout for calling it
    # because you call runSlideshow again with a new timeout in the complete on fadeOutSlideAdvance
    clearTimeout slideshowTimeout

    # clear any current image fade out timeouts, needed if you're quickly advancing
    # I don't think you need to worry about completing the fade b/c we set opacity and visibilty.
    clearTimeout fadeOutTimeout

    # if you're at the start (0) set the curImg to the slide total,
    # so it can loop backwards (can't go -1 on curImage, so (curImage - 1) % slides.length gives -1 )
    curImage = slides.length if curImage % slides.length is 0

    # make sure the prev slide is visible before the current one fades out
    setVisibilityForAdvance(prev)

    # set the opacity on the slide about to be revealed during the current image fade out
    setOpacity(slides[(curImage - 1) % slides.length], 100)

    # fade out for advancing slide
    fadeOutSlideAdvance(slides[curImage % slides.length], 100, prev)

    # current image iteration
    curImage--


  # little debugging calling this in the Chrome console before the show starts.
  timeoutClear: ->
    console.log "clearing... #{slideshowTimeout}"
    clearTimeout(slideshowTimeout);







# jQuery ->
#   console.log "yo, ready!"
#   STUDIO.makeSlideshow.initSlides("slideshow-wrapper")
