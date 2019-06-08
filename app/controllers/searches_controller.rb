class SearchesController < ApplicationController
  before_action :disable_feedback

  def show
    @q = params[:q]
    @analyzed_q = Transliterator.transliterate(@q)
    @searches = PgSearch::Document
                  .where(searchable_type: %w(Page Journey App))
                  .search(@analyzed_q)
                  .page(params[:page])
                  .per(10)
  end
end
