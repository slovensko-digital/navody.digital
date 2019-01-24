class StaticController < ApplicationController
  def index
    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.published
    if current_user
      @user_journeys = current_user.user_journeys.includes(:journey).order(id: :desc)
    end
  end

  def show
    @page = Page.where(is_faq: false).find_by!(slug: params[:id])
  end
end
