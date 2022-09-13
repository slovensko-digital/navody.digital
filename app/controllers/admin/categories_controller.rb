class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:edit, :update, :destroy, :feature, :hide]

  # GET /admin/categories
  def index
    @categories = Category.all
  end

  # GET /admin/categories/new
  def new
    @category = Category.new
  end

  # GET /admin/categories/1
  def show
    @category = Category.find_by!(id: params[:id])
    @documents = Document.featureable.searchable_with_category(@category).order(featured: :desc, featured_position: :asc)
  end

  # POST /admin/categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_url, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/categories/1
  def update
    if @category.update(category_params)
      redirect_to admin_categories_url, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def feature
    if @category.update(featured: true)
      redirect_back fallback_location: admin_categories_url, notice: 'Category was successfully updated.'
    end
  end

  def hide
    if @category.update(featured: false)
      redirect_back fallback_location: admin_categories_url, notice: 'Category was successfully updated.'
    end
  end

  # DELETE /admin/categories/1
  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: 'Category was successfully destroyed.'
  end

  private

  def set_category
    @category = Category.find_by!(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(
        :name,
        :description,
        :featured
    )
  end
end
