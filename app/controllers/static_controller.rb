class StaticController < ApplicationController
  def index
    @pages = Page.all # TODO: fetch top FAQs here
  end

  def show
    @page = Page.find_by_slug(params[:slug])
    raise ActionController::RoutingError.new('Not Found') unless @page
  end
end
