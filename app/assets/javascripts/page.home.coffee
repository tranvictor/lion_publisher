$ document
	.ready () ->

		# trending slider bind
		trendingSlider = $ 'div.trending ul.slides'
		if trendingSlider.length > 0 and typeof $(trendingSlider).bxSlider == 'function'
			trendingSlider = $ trendingSlider
				.bxSlider
					slideMargin: 0
					speed: 500
					pager: false
					adaptiveHeight: false
					useCSS: true
					prevText: '<i class="fa fa-angle-left"></i>'
					nextText: '<i class="fa fa-angle-right"></i>'

		$ 'div.trending'
			.css 'opacity', 1
			.find 'div.bx-viewport'
			.css 'overflow', 'visible'
			.click (e) ->
				unless $(e.target).prop('tagName') in ['A', 'H1']
					trendingSlider.goToNextSlide()
					
		# return
		null