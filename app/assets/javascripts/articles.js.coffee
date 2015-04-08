$ document
.ready () ->

  # trending slider bind
  # $ 'div.trending'
  # .trendingSlider()
  trendingSlider = $ 'div.trending ul.slides'
  .bxSlider
  	# slideMargin: 40
  	speed: 500
  	pager: false
  	adaptiveHeight: false
  	useCSS: true
  	prevText: '<i class="fa fa-angle-left"></i>'
  	nextText: '<i class="fa fa-angle-right"></i>'

  $ 'div.trending '

  $ 'div.trending div.bx-viewport'
  .css 'overflow', 'visible'
  .click (e) ->
  	unless $(e.currentTarget).prop('tagName') in ['A', 'H1']
  		trendingSlider.goToNextSlide()
  $ias = jQuery.ias
    container : '.feeds'
    item: '.article'
    pagination: '.pagination'
    next: '.next_page'
    delay: 1000
    negativeMargin: 300

  $ias.extension new IASSpinnerExtension
    html: '<div class="loader text-center"> <div class="spinner"> <div class="rect-1"></div> <div class="rect-2"></div> <div class="rect-3"></div> <div class="rect-4"></div> <div class="rect-5"></div> </div> </div>'
  # return
  null