class StaticController < ApplicationController
  def index
    @pages = Page.all # TODO: fetch top FAQs here
    @journeys = Journey.all
  end

  def show
    is_faq = !!params[:is_faq]
    @page = Page.where(is_faq: is_faq).find_by_slug(params[:slug])
    raise ActionController::RoutingError.new('Not Found') unless @page
  end
end
