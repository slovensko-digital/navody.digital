class StaticController < ApplicationController
  def index
    @pages = Page.all # TODO: fetch top FAQs here
    @journeys = Journey.all
  end

  def show
    @page = Page.where(is_faq: false).find_by_slug(params[:slug])
  end
end
