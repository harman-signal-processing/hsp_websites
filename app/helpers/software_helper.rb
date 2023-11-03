module SoftwareHelper

  # Use this for all software links so we can determine
  # if the link should show a popup when redirecting to
  # a non-Harman site
  def link_to_software(software, opts={})
    default_options = {
      label_method: :formatted_name
    }
    opts = default_options.merge(opts)
    link_text = software.send(opts[:label_method])

    # new record entries appear to be Martin firmware built on the fly
    if software.link.present? && software.new_record?
      link_to(link_text, software.link)

    # link to software details page if there is more info
    elsif software.has_additional_info?
      link_to(link_text, software)

    # link to software hosted by 3rd party, first show a popup
    elsif software.links_to_3rd_party_site?
      software_disclaimer_popup_for(software) +
      link_to(link_text, '#', data: { "reveal-id": "software_#{software.id}_popup"})

    else # default
      link_to(link_text, software)
    end
  end

  def software_disclaimer_popup_for(software)
    content_tag(:div,
      id: "software_#{software.id}_popup",
      class: "reveal-modal small",
      "data-reveal": true,
      role: "dialog",
      "aria-labelledby": "Disclaimer",
      "aria-hidden": true) do
        disclaimer_content_for(software) +
        link_to("Continue to download #{software.formatted_name}", software.link, target: "_blank", class: "button") +
        '<a class="close-reveal-modal" aria-label="Close">&#215;</a>'.html_safe
    end
  end

  def disclaimer_content_for(software)
    tag(:br) +
    content_tag(:p) do
      "You are leaving the #{ website.brand.name } / HARMAN International
      website to download the required software from a third party. HARMAN is
      not responsible for the accuracy of information on the third-party website.
      All rights reserved. Copyrights and trademarks are of the respective owners."
    end
  end

end