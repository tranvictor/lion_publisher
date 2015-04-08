(function() {
  $(document).ready(function() {
    $('div.embed > img').one('load', function() {
      var height, width;
      width = $(this).width();
      height = $(this).height();
      if (width > height) {
        return $(this).css('width', '100%');
      }
    }).each(function() {
      if (this.complete) {
        return $(this).load();
      }
    });
    if (typeof $.prototype.scrollToFixed === 'function') {
      $('div.facebook-box').scrollToFixed({
        marginTop: 30,
        minWidth: 640,
        zIndex: 9,
        limit: function() {
          var limit;
          limit = $(document).height() - $('section.bottom').outerHeight(true) - $('section.social').outerHeight(true) - $('div.facebook-box').outerHeight(true) - $('section.notifications').outerHeight(true) - 350;
          return limit;
        },
        unfixed: function() {
          return $('div.facebook-box').css({
            left: '15px',
            right: '15px',
            width: ''
          });
        }
      });
    }
    return null;
  });

}).call(this);
