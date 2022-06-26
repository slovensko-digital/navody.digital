class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(id: params[:id])
    @documents = Document.featured.includes(:searchable).order(featured_position: :asc).map(&:searchable).select{ |d| d.categories.include?(@category) }.compact
  end
end
