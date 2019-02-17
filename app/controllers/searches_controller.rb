class SearchesController < ApplicationController
  before_action :disable_feedback

  def show
    @q = params[:q]
    @journeys = Journey.published.search(@q).limit(5)
    @steps = Step.published.search(@q).limit(5)
    @pages = Page.faq.search(@q).limit(5)

    @count = @journeys.length + @steps.length + @pages.length
  end
end
