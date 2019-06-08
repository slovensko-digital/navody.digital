class Admin::AppsController < Admin::AdminController
  before_action :set_app, only: [:edit, :update, :destroy]

  # GET /apps
  def index
    @apps = App.all
  end

  # GET /apps/new
  def new
    @app = App.new
  end

  # GET /apps/1/edit
  def edit
  end

  # POST /apps
  def create
    @app = App.new(app_params)

    if @app.save
      redirect_to admin_apps_url, notice: 'App was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  def update
    if @app.update(app_params)
      redirect_to admin_apps_url, notice: 'App was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  def destroy
    @app.destroy
    redirect_to admin_apps_url, notice: 'App was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find_by(slug: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def app_params
    params.require(:app).permit(
      :title,
      :image_name,
      :published_status,
      :slug,
      :description
    )
  end
end
