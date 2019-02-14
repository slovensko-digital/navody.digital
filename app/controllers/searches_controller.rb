class SearchesController < ApplicationController
  before_action :disable_feedback

  def show
    @q = params[:q]
    analyzed_q = Transliterator.transliterate(@q)

    @journeys = Journey.published.where("search_terms @@ plainto_tsquery(?)", analyzed_q)
    @steps = Step.where("search_terms @@ plainto_tsquery(?)", analyzed_q)
    @pages = Page.faq.where("search_terms @@ plainto_tsquery(?)", analyzed_q)

    @count = @journeys.count + @steps.count + @pages.count
  end
end
