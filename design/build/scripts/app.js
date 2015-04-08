(function() {
  new WOW().init();

  $(document).ready(function() {
    var Alert, scrollTopButton, socialLinks, topSection;
    $(document).foundation();
    socialLinks = $('div.social-links');
    if (typeof $.prototype.bxSlider === 'function') {
      $(socialLinks).bxSlider({
        slideMargin: 0,
        speed: 500,
        pager: false,
        controls: false,
        adaptiveHeight: false,
        useCSS: true,
        auto: true,
        autoHover: true,
        autoStart: true,
        pause: 3000
      });
    }
    scrollTopButton = $('a.scroll-top');
    if (typeof $.scrollTo === 'function') {
      topSection = $('section.top');
      $(scrollTopButton).click(function() {
        return $.scrollTo($('body'), 1000);
      });
    }
    $('a.search-toggle').click(function() {
      $('.hide-on-search').toggleClass('hide');
      $('.show-on-search').toggleClass('hide');
      return $('div.search-form input[name="q"]').eq(0).focus();
    });
    $('section.content, section.menu').click(function() {
      if (!$('.show-on-search').hasClass('hide')) {
        return $('a.search-toggle').eq(0).click();
      }
    });
    $('ul.menu > li > a').click(function(e) {
      $('ul.menu > li').removeClass('active');
      $(this).parent().addClass('active');
      e.preventDefault();
      return $('body').attr('class', 'color-' + ($(this).parent().index() - 1)).find('div.header div.info p.category').text($(e.target).text());
    });
    $('section.menu a.toggle').click(function() {
      return $('section.menu ul.menu').toggleClass('show-for-medium-up');
    });
    Alert = {
      holder: $('section.notifications div.notifications'),
      add: function(text, type) {
        var item;
        if (type == null) {
          type = 'note';
        }
        if (this.holder.length > 0) {
          item = $("<div class=\"alert-box " + type + "\" data-alert>" + text + "<a class=\"close\">&times;</a></div>");
          $(item).hide().fadeIn('fast');
          $(this.holder).append($(item)).foundation();
          return item;
        }
      },
      update: function(item, text, type) {
        if (type == null) {
          type = 'note';
        }
        if ($(item).parent().is(this.holder)) {
          $(item).html("" + text + "<a class=\"close\">&times;</a>").attr('class', 'alert-box').addClass(type).foundation();
          return item;
        } else {
          return this.add(text, type);
        }
      },
      removeFirst: function() {
        return this.remove(0);
      },
      removeLast: function() {
        var index;
        index = $(this.holder).find('> div.alert-box').length - 1;
        return this.remove(index);
      },
      remove: function(index) {
        var item;
        if (typeof index === 'undefined') {
          this.removeFirst();
        }
        item = $(this.holder).find('> div.alert-box').eq(index);
        return this.removeItem(item);
      },
      removeItem: function(item) {
        if (typeof item !== 'undefined') {
          return $(item).fadeOut('fast', function() {
            return $(item).remove();
          });
        }
      },
      removeAll: function() {
        var items;
        if (this.holder.length > 0) {
          items = $(this.holder).find('> div.alert-box');
          return this.removeItem(items);
        }
      }
    };
    window.Alert = Alert;
    return null;
  });

}).call(this);
