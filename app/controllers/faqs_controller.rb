class FaqsController < ApplicationController
  def show
    @page = Page.faq.find_by_slug(params[:id])

  end
end
