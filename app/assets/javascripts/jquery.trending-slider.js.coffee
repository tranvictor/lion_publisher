do ($ = jQuery, window, document) ->
  pluginName = 'trendingSlider'
  defaults = {
    'animationDuration': '.5s'
    'currentSlide': 0
  }

  class Plugin
    slides: []
    currentIndex: 0
    previousIndex: 0
    nextIndex: 0
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @currentIndex = @settings.currentSlide
      @animateOptions =
        duration: 1000
        easing: 'easing'
      @slides = $ @element
      .find 'ul.slides > li'
      @init()

    bind: ->
      $ @slides
      .click (e) =>
        @previous()

    indexCalc: ->
      if @currentIndex >= @slides.length then @currentIndex = 0
      if @currentIndex < 0 then @currentIndex = @slides.length - 1
      @previousIndex = if @currentIndex > 0 then @currentIndex - 1 else @slides.length - 1
      @nextIndex = if @currentIndex < @slides.length - 1 then @currentIndex + 1 else 0

    classCalc: ->
      $ @slides
      .removeClass('active previous next ohide pre-right pre-left')
      for slide, index in @slides
        if $.inArray(index, [@previousIndex, @currentIndex, @nextIndex]) == -1
          $ slide
          .addClass 'ohide'
      $ @slides[@currentIndex]
      .addClass 'active'
      $ @slides[@previousIndex]
      .addClass 'previous'
      $ @slides[@nextIndex]
      .addClass 'next'

    init: ->
      @bind()
      @indexCalc()
      @classCalc()

    next: ->
      @currentIndex++
      @indexCalc()
      @classCalc()

    previous: ->
      @currentIndex--
      @indexCalc()
      @classCalc()

  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Plugin @, options