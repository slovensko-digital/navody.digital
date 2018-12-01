class SearchController < ApplicationController
  def show
    @q = params[:q]
    analyzed_q = Transliterator.transliterate(@q)

    @journeys = Journey.where("search_terms @@ to_tsquery(?)", analyzed_q)
    @steps = Step.where("search_terms @@ to_tsquery(?)", analyzed_q)
  end
end
