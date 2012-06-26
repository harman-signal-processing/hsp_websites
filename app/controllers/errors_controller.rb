class ErrorsController < ApplicationController
  def four_oh_four
    error_page(404)
  end

  def five_hundred
    error_page(500)
  end

end
