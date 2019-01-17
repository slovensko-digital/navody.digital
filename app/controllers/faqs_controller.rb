class FaqsController < ApplicationController
  def index
    @pages = Page.faq
  end

  def show
    @page = Page.faq.find_by_slug(params[:id])
  end
end
