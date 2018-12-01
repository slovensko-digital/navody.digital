class SearchController < ApplicationController
  def show
    @q = params[:q]
    stemmed_q = Settings.stemmer.call(@q)

    @journeys = Journey.where("search_terms @@ to_tsquery(?)", stemmed_q)
    @steps = Step.where("search_terms @@ to_tsquery(?)", stemmed_q)
  end
end
