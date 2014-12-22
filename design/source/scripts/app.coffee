# new WOW().init()
$ document
  .ready () ->

    # foundation bind
    $ document
      .foundation()

    # social links slider bind
    socialLinks = $ 'div.social-links'
    if typeof $.prototype.bxSlider == 'function'
      $ socialLinks
        .bxSlider
          slideMargin: 0
          speed: 500
          pager: false
          controls: false
          adaptiveHeight: false
          useCSS: true
          auto: true
          autoHover: true
          autoStart: true
          pause: 3000

    # scroll badge bind
    scrollTopButton = $ 'a.scroll-top'
    if typeof $.scrollTo == 'function'
      topSection = $ 'section.top'
      $ scrollTopButton
        .click () ->
          $.scrollTo $('body'), 1000
      $ window
        .scroll () ->
          if $(window).scrollTop() > 400
            $ scrollTopButton
            .show() if $(window).width() >= 640
          else
            $ scrollTopButton
            .hide()
        .scroll()

    # search toggle bind
    $ 'a.search-toggle'
      .click () ->
        $ '.hide-on-search'
          .toggleClass 'hide'
        $ '.show-on-search'
          .toggleClass 'hide'
        $ 'div.search-form input[name="q"]'
          .eq 0
          .focus()

    # search box hide toggle bind
    $ 'section.content, section.menu'
      .click () ->
        unless $ '.show-on-search'
          .hasClass 'hide'
            $ 'a.search-toggle'
              .eq 0
              .click()

    # color theme activator
    $ 'ul.menu > li > a'
      .click (e) ->
        $ 'ul.menu > li'
          .removeClass 'active'
        $ this
          .parent()
          .addClass 'active'
        e.preventDefault()
        $ 'div.page'
          .attr 'class', 'page feed'
          .addClass 'color-' + $(this).parent().index()

    # menu toggle bind
    $ 'section.menu a.toggle'
      .click () ->
        $ 'section.menu ul.menu'
          .toggleClass 'show-for-medium-up'

    # notifications scroll to fixed
    if typeof $.prototype.scrollToFixed == 'function'
      $ 'section.notifications'
        .scrollToFixed
          marginTop: 110

    #  notifications
    Alert =
      holder: $ 'section.notifications div.notifications'
      add: (text, type = 'note') ->
        if @holder.length > 0
          item = $ "<div class=\"alert-box #{type}\" data-alert>#{text}<a class=\"close\">&times;</a></div>"
          $ item
            .hide()
            .fadeIn('fast')
          $ @holder
            .append $ item
            .foundation()
          item
      update: (item, text, type = 'note') ->
        if $(item).parent().is(@holder)
          $ item
            .html "#{text}<a class=\"close\">&times;</a>"
            .attr 'class', 'alert-box'
            .addClass type
            .foundation()
          return item
        else
          return @add text, type
      removeFirst: () ->
        @remove 0
      removeLast: () ->
        index = $(@holder).find('> div.alert-box').length - 1
        @remove index
      remove: (index) ->
        if typeof index == 'undefined' then @removeFirst()
        item = $ @holder
          .find '> div.alert-box'
          .eq index
        @removeItem item
      removeItem: (item) ->
        if typeof item != 'undefined'
          $ item
            .fadeOut 'fast', () ->
              $ item
                .remove()
      removeAll: () ->
        if @holder.length > 0
          items = $ @holder
            .find '> div.alert-box'
          @removeItem items

    window.Alert = Alert

    # return
    null