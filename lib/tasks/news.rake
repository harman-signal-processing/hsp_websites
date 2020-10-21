namespace :news do

  desc "Merge news articles with the same title"
  task dedup: :environment do
    removed = []

    News.group(:title).each do |keeper|
      articles = News.where(title: keeper.title).where.not(id: keeper.id)
      if articles.length > 0
        puts "Found #{articles.length} duplicates titled: #{keeper.title}"
        articles.each do |article|
          article.brands.each do |b|
            keeper.brands << b unless keeper.brands.include?(b)
          end
          article.products.each do |p|
            keeper.products << p unless keeper.products.include?(p)
          end
          article.destroy
          removed << article
        end
        keeper.save
        puts "   Now 1 exists for #{ keeper.brands.pluck(:name).join(', ') }."
      end
    end

    puts "Removed #{ removed.length } articles"

  end

end
