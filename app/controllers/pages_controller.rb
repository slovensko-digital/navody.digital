class PagesController < ApplicationController
  def index
    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.published
    if current_user
      @user_journeys = current_user.user_journeys.includes(:journey).order(id: :desc)
    end
  end

  def show
    @page = Page.find_by_slug!(params[:id])
  end
end
