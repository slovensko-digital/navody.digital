class SearchesController < ApplicationController
  before_action :disable_feedback

  def show
    @q = params[:q]
    analyzed_q = Transliterator.transliterate(@q)
    @searches = PgSearch.multisearch(analyzed_q).page(params[:page]).per(2)
  end
end
