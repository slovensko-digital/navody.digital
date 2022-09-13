class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(id: params[:id])
    @documents = Document.featured.searchable_with_category(@category).order(featured: :desc, featured_position: :asc).map{ |d| d.searchable }
  end
end
