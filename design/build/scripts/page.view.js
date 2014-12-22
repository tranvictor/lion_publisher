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
        marginTop: 130,
        minWidth: 640,
        zIndex: 9,
        limit: function() {
          var limit;
          limit = $(document).height() - $('section.bottom').outerHeight(true) - $('div.facebook-box').outerHeight(true) - $('section.notifications').outerHeight(true) - 350;
          return limit;
        },
        fixed: function() {
          return $('div.facebook-box').css({
            width: $('div.facebook-box').width() + 30,
            right: ''
          });
        },
        unfixed: function() {
          return $('div.facebook-box').css({
            left: 0,
            right: 0,
            width: ''
          });
        }
      });
    }
    return null;
  });

}).call(this);
