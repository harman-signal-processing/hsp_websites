module MarketingQueue::BrandsHelper

  def month_link(month_date)
    link_to(I18n.localize(month_date, format: "%B"), {month: month_date.month, year: month_date.year})
  end

  # custom options for this calendar
  def event_calendar_options
    { 
      year: @year,
      month: @month,
      event_strips: @event_strips,
      month_name_text: I18n.localize(@shown_month, :format => "%B %Y"),
      height: 500,
      previous_month_text: nil, #"<< " + month_link(@shown_month.prev_month),
      next_month_text: nil #month_link(@shown_month.next_month) + " >>"
    }
  end

  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      name = (event.brand.present?) ? "#{event.brand.name}: #{event.name}" : "#{event.name}"
      path = url_for([:marketing_queue, event])
      %(<a href="#{path}" title="#{h(event.name)}">#{h(name)}</a>)
    end
  end
  
  def event_calendars
    output = ""
    this_date = @start_on.to_date
    until this_date > @end_on.to_date
      @month = this_date.month.to_i
      @year = this_date.year.to_i
      @shown_month = Date.civil(@year, @month)
      @event_strips = @brand.event_strips_for_month(@shown_month)
      output << event_calendar.html_safe
      this_date = this_date.next_month
    end
    raw(output)
  end

  def marketing_event_calendars #Jay's new calendar
    options = {}
    options[:brand_id] = @brand.id if @brand
    output = ""
    this_date = @start_on.to_date
    until this_date > @end_on.to_date
      @month = this_date.month.to_i
      @year = this_date.year.to_i
      @shown_month = Date.civil(@year, @month)
      @event_strips = @marketing_calendar.event_strips_for_month(@shown_month, options)
      output << event_calendar.html_safe
      this_date = this_date.next_month
    end
    raw(output)    
  end
end
