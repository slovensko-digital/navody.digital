class SearchesController < ApplicationController
  def show
    @q = params[:q]
    analyzed_q = Transliterator.transliterate(@q)

    @journeys = Journey.where("search_terms @@ to_tsquery(?)", analyzed_q)
    @steps = Step.where("search_terms @@ to_tsquery(?)", analyzed_q)
    @pages = Page.faq.where("search_terms @@ to_tsquery(?)", analyzed_q)

    @count = @journeys.count + @steps.count + @pages.count
  end
end
