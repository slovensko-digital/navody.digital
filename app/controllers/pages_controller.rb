class PagesController < ApplicationController
  def index
    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.published
  end

  def show
    @page = Page.find_by_slug!(params[:id])
  end
end
