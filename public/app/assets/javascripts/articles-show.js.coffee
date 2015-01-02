$ document
  .ready () ->

    # image sizing
    $ 'div.embed > img'
      .one 'load', () ->
        width = $(this).width()
        height = $(this).height()
        $(this).css 'width', '100%' if width > height
      .each () ->
        if this.complete
          $(this).load()

    # facebook box and scroll to fixed
    if typeof $.prototype.scrollToFixed == 'function'
      $ 'div.facebook-box'
        .scrollToFixed
          marginTop: 130
          minWidth: 640
          zIndex: 9
          limit: () ->
            limit = $(document).height() - $('section.bottom').outerHeight(true) - $('div.facebook-box').outerHeight(true) - $('section.notifications').outerHeight(true) - 350
            return limit
          fixed: () ->
            $ 'div.facebook-box'
              .css
                width: $('div.facebook-box').width() + 30
                right: ''
          unfixed: () ->
            $ 'div.facebook-box'
              .css
                left: 0
                right: 0
                width: ''
    # return
    null
