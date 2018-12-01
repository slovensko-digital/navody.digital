class StaticController < ApplicationController
  def index
    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.all
  end

  def show
    @page = Page.where(is_faq: false).find_by_slug(params[:slug])
  end
end
