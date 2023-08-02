namespace :bot do

  desc "Crawl forms to find contact forms"
  task crawl_forms: :environment do
    tracker_file = Rails.root.join("db", "acoustic-forms.csv")
    output_file = Rails.root.join("db", "acoustic-forms-wformurls.csv")

    agent = Mechanize.new

    i = 0
    CSV.open(output_file, "wb") do |csv_out|
      CSV.foreach(tracker_file, headers: true) do |row|
        i += 1
        page_url = row[0]
        puts "#{i}: Reading: #{page_url}"

        column = 3
        begin
          res = agent.get(page_url)

          if res.iframes.size > 0
            res.iframes.each do |iframe|
              if iframe.src.to_s.match?(/pages08/i)
                row[column] = iframe.src.strip
                puts "  iframe found: #{row[column]}"
                column += 1
              end
            end
          end

          if res.forms.size > 0
            res.forms.each do |form|
              if form.action.to_s.match?(/pages08/i)
                row[column] = form.action.strip
                puts "   form found: #{row[column]}"
                column += 1
              end
            end
          end

          sleep(3)
        rescue Mechanize::UnauthorizedError
          row[column] = "(unauthorized)"
          puts "  (unauthorized) "
        rescue
          puts "   --- some other kind of error ---"
        end
        csv_out << row
      end
    end

  end

end