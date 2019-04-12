class StaticController < ApplicationController

  def index
    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.published
  end

  def show
    @page = Page.where(is_faq: false).find_by!(slug: params[:id])
  end
end
