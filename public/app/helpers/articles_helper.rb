module ArticlesHelper
  def top_nav_button(index, length, next_article, html_class='')
    button_pair '< Prev', index, length, next_article, html_class
  end

  def bottom_nav_button(index, length, next_article, html_class='')
    button_pair '< Previous', index, length, next_article, html_class
  end

  def prev_button(value, index, html_class='')
    index > 0 ? nav_button(value, index - 1, html_class) : ''
  end

  def next_button(value, index, length, next_article, html_class='')
    index < length - 1 ?
      nav_button(value, index + 1, html_class)
    :
      nav_button(value, next_article, html_class)
  end

  def dfp_header_mobile(subdomain)
    header = Advertise.first.dfp_header_mobile
    dfp_header(subdomain, header).html_safe
  end

  def dfp_header_desktop(subdomain)
    header = Advertise.first.dfp_header_desktop
    dfp_header(subdomain, header).html_safe
  end

  private
  def button_pair(value, index, length, next_article, html_class='')
    prev_html = prev_button value, index, html_class
    next_html = next_button 'Next >', index, length, next_article, html_class
    "#{prev_html} #{next_html}".html_safe
  end

  def nav_button(value, target, html_class='')
    link_to raw(value), target_object(target),
            {:class => "#{html_class}"}
  end

  def target_object(target)
    target.is_a?(Integer) ? {:page => target} : target
  end

  def dfp_header(subdomain, header)
    subdomain = 'main' if subdomain == ''
    header += <<-HTML
    <script type='text/javascript'>
      googletag.pubads().setTargeting('Affiliate', '#{subdomain}');
    </script>
    HTML
  end

end
