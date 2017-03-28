class FaqCategoriesController < ApplicationController
  before_action :set_locale

  def index
    @faq_categories = website.faq_categories_with_faqs
  end

  def show
    @faq_category = FaqCategory.find(params[:id])
  end
end
