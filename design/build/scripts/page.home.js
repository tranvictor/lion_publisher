(function() {
  $(document).ready(function() {
    var trendingSlider;
    trendingSlider = $('div.trending ul.slides');
    if (trendingSlider.length > 0 && typeof $(trendingSlider).bxSlider === 'function') {
      trendingSlider = $(trendingSlider).bxSlider({
        slideMargin: 40,
        speed: 500,
        pager: false,
        adaptiveHeight: false,
        useCSS: true,
        prevText: '<i class="fa fa-angle-left"></i>',
        nextText: '<i class="fa fa-angle-right"></i>'
      });
    }
    $('div.trending div.bx-viewport').css('overflow', 'visible').click(function(e) {
      var _ref;
      if ((_ref = $(e.target).prop('tagName')) !== 'A' && _ref !== 'H1') {
        return trendingSlider.goToNextSlide();
      }
    });
    return null;
  });

}).call(this);
