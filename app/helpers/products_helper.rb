module ProductsHelper

  # Links to product using the relevant locale for the product to avoid redirects.
  # Also uses the product's brand's website host if it isn't the same as the current
  # website.
  def best_product_url(product)
    best_locale = I18n.default_locale
    product_locales = product.locales(website)
    if product_locales.size > 0
      best_locale = product_locales.include?(I18n.locale.to_s) ? I18n.locale : product_locales.first
    end

    if product.brand_id == website.brand_id
      product_url(product, locale: best_locale)
    else
      product_url(product, locale: best_locale, host: product.brand.default_website.url)
    end
  end

  def link_to_product_attachment(product_attachment)
    if product_attachment.product_attachment_file_name.present?
      link_to product_attachment.product_attachment.url(:original),
        data: product_attachment.no_lightbox? ? {} : { fancybox: 'product-thumbnails' } do
          image_tag(product_attachment.product_attachment.url(:tiny), alt: "product thumbnail", style: 'vertical-align: middle')
      end
    else
      img = product_attachment.product_media_thumb.url(:tiny)
      if product_attachment.product_media_file_name.to_s.match(/swf$/i)
        width = (product_attachment.width.blank?) ? "100%" : product_attachment.width
        height = (product_attachment.height.blank?) ? "100%" : product_attachment.height
        new_content = swf_tag(product_attachment.product_media.url, size: "#{width}x#{height}")
        link_to_function image_tag(img, style: "vertical-align: middle", alt: "flash"), "$('#viewer').html('#{escape_javascript(new_content)}')"
      elsif product_attachment.product_media_file_name.to_s.match(/flv|mp4|mov|mpeg|mp3|m4v$/i)
        link_to product_attachment.product_media.url,
          data: product_attachment.no_lightbox? ? {} : { fancybox: 'product-thumbnails' } do
            image_tag(img, style: 'vertical-align: middle', alt: "Product Video")
        end
      else
        new_content = product_attachment.product_attachment.url
        link_to_function image_tag(img, style: "vertical-align: middle", alt: product_attachment.product_attachment_file_name), "$('#viewer').html('#{escape_javascript(new_content)}')"
      end
    end
  end

  def tab_title(product_tab, options={})
    title = options[:shorten] ? t("product_page.labels.#{product_tab.key}") : t("product_page.#{product_tab.key}")
    if I18n.locale.to_s.match(/en/)
      if options[:product] && custom_title = options[:product].rename_tab(product_tab.key)
        title = custom_title
      elsif custom_title = eval("website.#{product_tab.key}_tab_name")
        title = custom_title
      end
    end
    (product_tab.count.to_i > 1) ? "#{product_tab.count} #{title}" : title
  end

  # Zurb's way of doing the accordion I had previously hand-written
  # Note: this usually appears under the side nav and is intended for short content
  def draw_info_accordion(product, options={})
    acc = ""
    side_tabs = product.collect_tabs(website.brand.side_tabs)

    side_tabs.each_with_index do |product_tab, i|
      active = "active" if i == 0
      title = link_to(tab_title(product_tab), "##{product_tab.key}")
      content = content_tag(:div, id: product_tab.key, class: "content #{active}") do
        render_partial("products/#{product_tab.key}", product: product)
      end
      acc += content_tag(:dd, class: "accordion-navigation") do
        title + content
      end
    end

    content_tag(:dl,
      acc.html_safe,
      class: "accordion",
      data: {accordion: true})
  end

  def draw_side_nav(product, options={})
    # set collapse_content to true at the brand or product level to use accordion
    # instead of side nav. When collapse_content = true, side nav retains links to
    # photometrics, parts and hpro contact buttons
    collapse_content = product.collapse_content? || product.brand.collapse_content?

    main_tabs = product.main_tabs
    side_links = []
    ret = "<div class='side-nav-container' data-magellan-expedition='static'>"
    if main_tabs.size > 1
      main_tabs.each_with_index do |product_tab,i|
        if options[:active_tab]
          current = (product_tab.key == options[:active_tab]) ? "active" : ""
        else
          current = (i == 0) ? "active" : ""
        end
        if product_tab.key == "photometrics"
          side_links << content_tag(
            :dd,
            link_to(
              tab_title(product_tab, product: product),
              photometric_product_url(product),
              target: "_blank"
            )
          )
        elsif product_tab.key == "parts"
          if can?(:read, Part)
            side_links << content_tag(
              :dd,
              link_to(
                "#{tab_title(product_tab, product: product)} #{fa_icon('key')}".html_safe,
                bom_product_path(product)
              )
            )
          end
        else
          side_links << content_tag(
            :dd,
            link_to(
              tab_title(product_tab, product: product),
              "##{product_tab.key}",
            ),
            class: current,
            data: {
              :'magellan-arrival' => product_tab.key
            }
          ) unless collapse_content
        end
      end
      if side_links.size > 0
        ret += content_tag(:dl, raw(side_links.join("")), class: "side-nav")
        ret += tag.hr
      end
    end
    unless hide_contact_buttons?(product)
      ret += hpro_contact_buttons
    end
    ret += "</div>"
    raw(ret)
  end

  def draw_main_product_content(product, options={})
    main_tabs = product.main_tabs

    # set collapse_content to true at the brand or product level to use accordion
    collapse_content = product.collapse_content? || product.brand.collapse_content?

    ret = ""
    first_tab = main_tabs[0]
    if options[:active_tab]
      active_class = (first_tab.key == options[:active_tab]) ? "active" : ""
    else
      active_class = "active"
    end
    ret += content_tag(:div, class: "product_main_tab_content content #{active_class}") do
      render_partial("products/#{first_tab.key}", product: product)
    end

    main_tabs_content = ""
    main_tabs.each_with_index do |product_tab,i|
      next if i == 0 || product_tab.key == "photometrics" || product_tab.key == "parts"

      if options[:active_tab]
        active_class = (product_tab.key == options[:active_tab]) ? "active" : ""
      else
        active_class = ""
      end

      this_tab_content = ""
      if collapse_content
        this_tab_content += link_to("#panel_#{product_tab.key}") do
          content_tag(:h3, tab_title(product_tab, product: product))
        end
      else
        this_tab_content += link_to('', '', name: product_tab.key)
        this_tab_content += content_tag(:div, '', class: "overline")
        this_tab_content += content_tag(:div, class: "row product-subheader", id: "product-#{product_tab.key}") do
            content_tag(:div, class: "small-10 columns") do
              content_tag(
              :h3,
              tab_title(product_tab, product: product),
              class: 'content-nav',
              data: {:'magellan-destination' => product_tab.key}
            )
          end + admin_links_for(product_tab, product)
        end
      end

      this_tab_content += content_tag(:div, class: "product_main_tab_content content #{active_class}", id: "panel_#{product_tab.key}") do
        render_partial("products/#{product_tab.key}", product: product)
      end

      main_tabs_content += collapse_content ?
        content_tag(:dd, raw(this_tab_content), class: "accordion-navigation") :
        this_tab_content
    end

    ret += collapse_content ?
      content_tag(:dl, raw(main_tabs_content), class: "accordion", data: {accordion: true}) :
      main_tabs_content

    raw(ret)
  end

  def admin_links_for(product_tab, product)
    content_tag(:div, class: "small-2 columns text-right") do
      if can?(:manage, product)
        if product_tab.key.match?(/download|doc/)
          admin_downloads_link(product)
        elsif product_tab.key.match?(/spec/)
          admin_specs_link(product)
        end
      end
    end
  end

  def admin_downloads_link(product)
    link_to(admin_product_path(product), class: "edit-link", data: {opener: 'upload-options'}) do
      fa_icon("upload") + " upload"
    end +
    content_tag(:div, class: "dialog", id: "upload-options") do
      link_to(new_site_element_path(product_id: product.to_param), id: "upload-site-element-button", class: "tiny button") do
        fa_icon("upload") + " new resource"
      end + ' ' +
      link_to(new_software_path(product_id: product.to_param), class: "tiny button") do
        fa_icon("upload") + " new software"
      end
    end
  end

  def admin_specs_link(product)
    reveal_id = website.brand.use_flattened_specs? ? "edit-specs" : "add-spec-group"

    link_to( admin_product_specifications_path(product), class: "reveal-edit-link", data: { "reveal-id": reveal_id }) do
      fa_icon(reveal_id.match?(/edit/) ? "edit" : "plus") + " #{ reveal_id.gsub(/\-/, ' ') }"
    end
  end

  # Shows the HTML5 audio demos for this product
  def draw_audio_demos(product)
    ret = ""
    if product.audio_demos.size > 0
      # ret += '<div id="sm2-container"></div>'
      ret += '<ul class="graphic">'
      product.audio_demos.each do |audio_demo|
        ret += content_tag(:li, link_to(audio_demo.name, audio_demo.wet_demo.url, class: "sm2_link"))
      end
      ret += "</ul>"
    end
    raw(ret)
  end

  def buy_it_now_link(product, options={})
    if !product.discontinued?

      default_options = {button_prefix: ""}
      options = default_options.merge options
      button = button_for(product, options)

      if !product.in_production? || product.eol?
        no_buy_it_now(product)
      elsif product.hide_buy_it_now_button?
        ""
      elsif !(I18n.locale.to_s.match(/en/i))
        buy_it_now_international(product, button, options)
		  elsif !product.direct_buy_link.blank?
        buy_it_now_direct_from_factory(product, button, options)
      elsif !!product.exclusive_retailer_link
        buy_it_now_exclusive(product, button, options)
      elsif @online_retailer_link # http param[:bin] provided
        buy_it_now_direct_to_retailer(product, button)
		  else
        buy_it_now_usa(product, button, options)
		  end
		end
  end

  def folder_for(product)
    (product.layout_class.to_s.match(/vocalist/)) ? product.layout_class : website.folder
  end

  def button_for(product, options)
    if product.direct_buy_link.blank?
      text = t("buy_it_now")
    elsif !!product.exclusive_retailer_link
      text = t("buy_it_now")
    elsif product.parent_products.size > 0 # as in e-pedals
      text = t("get_it")
    else
      text = t("add_to_cart")
    end
    text = text.downcase if options[:downcase]
    text
  end

  def no_buy_it_now(product)
    if product.show_on_website?(website)
      content_tag(:div, product.product_status.name.titleize, class: "product_status_badge")
    else
      content_tag(:div, "Confidential", class: "product_status_badge")
    end
  end

  def buy_it_now_usa(product, button, options)
    button_class = button_class(button, options)
    if product.active_retailer_links.size > 0
      # tracker (old) = (Rails.env.production?) ? "_gaq.push(['_trackEvent', 'BuyItNow', 'USA', '#{product.name}']);" : ""
      # tracker (new) = (Rails.env.production?) ? "gtag('event', 'click', { 'event_category': 'BuyItNow', 'event_action': 'USA', 'event_label': '#{product.name}' });" : ""
      # link_to_function button, "#{tracker}popup('dealer_popup');"
      button_class += " buy_it_now_popup"

      html5_data = (options[:reveal_id]) ? {:'reveal-id' => options[:reveal_id]} : {windowname: 'dealer_popup'} # for old home-grown popup

      link_to(button,
        buy_it_now_product_path(product),
        class: button_class,
        data: html5_data,
        onclick: raw("gtag('event', 'click', { 'event_category': 'BuyItNow', 'event_action': 'USA', 'event_label': '#{product.name}' })"))
    else
      link_to(button,
        where_to_find_path,
        class: button_class,
        onclick: raw("gtag('event', 'click', { 'event_category': 'BuyItNow', 'event_action': 'Without online retailer links', 'event_label': '#{product.name}' })"))
    end
  end

  def buy_it_now_direct_to_retailer(product, button, options={})
    link_to(button,
      @online_retailer_link.url,
      class: button_class(button, options),
      target: "_blank",
      onclick: raw("gtag('event', 'click', { 'event_category': 'BuyItNow-Dealer', 'event_action': '#{@online_retailer_link.online_retailer.name}', 'event_label': '#{product.name}' })"))
  end

  def buy_it_now_exclusive(product, button, options={})
    link_to(button,
      product.exclusive_retailer_link.url,
      class: button_class(button, options) + " buy_it_now_popup",
      data: (options[:reveal_id]) ? {:'reveal-id' => options[:reveal_id]} : {windowname: 'dealer_popup'},
      onclick: raw("gtag('event', 'click', { 'event_category': 'BuyItNow-Exclusive', 'event_action': '#{product.exclusive_retailer_link.online_retailer.name}', 'event_label': '#{product.name}' })"))
  end

  def buy_it_now_direct_from_factory(product, button, options={})
    link_to(button,
      product.direct_buy_link,
      class: button_class(button, options),
      target: "_blank",
      onclick: raw("gtag('event', 'click', { 'event_category': 'AddToCart', 'event_action': 'USA (#{session['geo_country']})', 'event_label': '#{product.name}' })"))
  end

  def buy_it_now_international(product, button, options={})
    link_to(button,
      international_distributors_path,
      class: button_class(button, options),
      onclick: raw("gtag('event', 'click', { 'event_category': 'BuyItNow', 'event_action': 'non-USA (#{session['geo_country']})', 'event_label': '#{product.name}' })"))
  end

  # Used by the different buy it now methods to determine what kind of CSS class (if any)
  # to assign to the generated button
  #
  def button_class(button, options={})
    options[:button_class] ? options[:button_class] : "buy-button button medium"
  end

  def links_to_current_promotions(product, options={})
    format = options[:format] || "full"
    begin
      if I18n.locale.to_s.match?(/us/i)
        if product.current_promotions.size == 1
          promo = product.current_promotions.first
          alt_url = (promo.promo_form_file_name.blank?) ? promotions_path : promo.promo_form.url
          if format == "text_only"
            content_tag(:div, link_to(promo.name, (promo.has_description?) ? promo : alt_url))
          else
            tag(:br) +
            content_tag(:h2, class: "special_offer") {
              link_to(t('product_page.special_offer'), (promo.has_description?) ? promo : alt_url)
            } + content_tag(:div, class: "special_offer_contents") {
              link_to(promo.name, (promo.has_description?) ? promo : alt_url)
            }
          end
        elsif product.current_promotions.size > 1
          if format == "text_only"
            content_tag(:div, link_to(t('product_page.specal_offer'), promotions_path))
          else
            tag(:br) +
            content_tag(:h2, class: "special_offer") {
              link_to(t('product_page.special_offer'), promotions_path)
            }
          end
        end
      end
    rescue
      ""
    end
  end

  def breadcrumbs(item)
    crumbs = []
    crumbs << link_to(t('home').titleize, root_path)

    if website.brand.name.match(/amx/i) && item.cached_slug.start_with?('jitc-')  # this is just for AMX jitc product family pages
      crumbs << link_to('Support', support_path)
      crumbs << link_to('Security', '/secureav')
    else
      crumbs << link_to(t('products').titleize, product_families_path)
    end

    if item.is_a?(Product)
      if primary_family = item.primary_family(website)
        crumbs += product_family_crumbs(primary_family)
        if primary_family.current_products_plus_child_products(website).length > 1
          crumbs << link_to(translate_content(primary_family, :name), primary_family) unless primary_family.requires_login?
        end
      end

    elsif item.is_a?(ProductFamily)
      crumbs += product_family_crumbs(item)
    end

    crumbs << content_tag(:span, translate_content(item, :name), class: "current")
    raw(crumbs.uniq.join(" &gt; "))
  end

  def product_family_crumbs(product_family)
    product_family.ancestors.reverse.map do |pf|
      if pf.current_products_plus_child_products(website).length > 1
        link_to(translate_content(pf, :name), pf) unless pf.requires_login?
      end
    end
  end

  # Figure out which is the image path for the toggle effect on
  def effect_on_image_path(product)
    images = product.images_for("product_page")
    if images.size >= 3
      images[2].product_attachment.url(:epedal)
    else
      product.photo.product_attachment.url(:epedal)
    end
  end

  def swf_tag(source, options={}, &block)
    link_to("Download legacy resource", source)
  end

  # Returns a checkmark if the specification value is "yes"
  def spec_value(product_spec)
    val = product_spec.value
    (val.match(/^yes\s*?$/i)) ? image_tag("icons/check.png", alt: val) : raw(translate_content(product_spec, :value))
  end

  def render_parts_tree(nodes, options={})
    options[:ulid] ||= "partslist"
    return ''.html_safe if nodes.empty?
    content_tag(:ul, id: options[:ulid]) do
      nodes.map do |node|
        content_tag(:li) do
          render_part(node.part) + render_parts_tree(node.children, ulid: "node_#{node.id}")
        end
      end.join.html_safe
    end
  end

  def render_part(part)
    img = part.photo.present? ?
      link_to(image_tag(part.photo.url(:tiny_square), alt: part.part_number), "#", data: {:"reveal-id" => "modal#{part.id}"}) :
      "&nbsp;".html_safe
    desc = content_tag(:h5) do
      link_to(part.part_number, '#', data: {:"reveal-id" => "modal#{part.id}"})
    end + part.description
    content_tag(:table, style: "width: 100%") do
      content_tag(:tr) do
        content_tag(:td, img, style: "width: 100px") + content_tag(:td, desc)
      end
    end
  end

  def keys_for(site_element)
    begin
      if site_element.access_level.present?
        "&nbsp;" +
          site_element.access_level.keys.times.map do
            fa_icon("key")
        end.join
      end.to_s.html_safe
    rescue
      ""
    end
  end

  # For Martin, list the names of the resource types in the order they
  # should appear on the page. Anything else, will just appear after the
  # sorted results.
  def download_group_sort_order(resource_type_name)
    resource_types_in_order.include?(resource_type_name) ?  resource_types_in_order.index(resource_type_name) : 99
  end

  def resource_types_in_order
    @resource_types_in_order ||= (website.resource_type_order.present?) ?
      website.resource_type_order.split(/\r\n|\r|\n/) :
      [
        "Specifications", "Specification",
        "Manuals", "Manual",
        "Photometric", "Photometrics",
        "Brochures", "Brochure",
        "Illustrations", "Illustration",
        "Symbols", "Symbol",
        "CAD Drawings", "CAD Drawing",
        "Compliance", "Compliances",
        "Tech Notes", "Tech Note",
        "Technical Papers", "Technical Paper",
        "Servicee Notes", "Service Note",
        "Software",
        "Hints And Tips",
        "Parts", "Part"
      ]
  end

  def hpro_contact_buttons
    find_a_dealer = content_tag :div, class: "medium-6 small-12 columns" do
      link_to "#{ENV['PRO_SITE_URL']}/contacts/channel",
        target: "_blank",
        class: "hpro-button button expand find-a-dealer" do
        image_tag("find_dealer.png", alt: "f", lazy: false) + t("find_a_dealer")
      end
    end
    have_a_question = content_tag :div, class: "medium-6 small-12 columns" do
      link_to "#{ENV['PRO_SITE_URL']}/contacts",
        target: "_blank",
        class: "hpro-button button expand have-a-question" do
        image_tag("have_question.png", alt: "q", lazy: false) + t("have_a_question")
      end
    end
    contact_consultant = content_tag :div, class: "medium-12 small-12 columns" do
      link_to "#{ENV['PRO_SITE_URL']}/consultant",
        target: "_blank",
        class: "hpro-button button expand contact-consultant" do
        image_tag("contact-consultant.png", alt: "c", lazy: false) + t("contact_consultant")
      end
    end
    buttons = find_a_dealer + have_a_question
    buttons += contact_consultant if website.brand.show_consultant_button?
    content_tag(:div, class: "hpro-buttons-label")do
      "HARMAN Professional Solutions:"
    end +
    content_tag(:div, buttons, class: "row collapse")
  end

  def hide_contact_buttons?(product)
    !!(website.brand.name.match(/dbx|Lexicon/i) || product.hide_contact_buttons?)
  end

  def item_version(item)
    version = ''
    if item.is_a?(Software)
      version = item.version
      if item.platform.present?
        if item.platform.to_s.match(/power\s?pc/i)
          version += " (Power PC)"
        elsif item.platform.to_s.match(/intel/i)
          version += " (Intel)"
        end
      else
        version
      end
    elsif item.respond_to?(:version)
      version = item.version
    end

    version

  end  #  def item_version(item)

end
