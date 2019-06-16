class Admin::DocumentsController < Admin::AdminController
  before_action :set_document, only: [:show, :edit, :update]

  # GET /admin/documents
  def index
    @documents = PgSearch::Document.where(searchable_type: ['Journey', 'App']).includes(:searchable).select(&:searchable)
  end

  # GET /admin/documents/1/edit
  def edit
  end

  # PATCH/PUT /admin/journeys/1
  def update
    if @document.update(document_params)
      redirect_to admin_documents_url, notice: 'Document was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_document
    @document = PgSearch::Document.find(params[:id])
  end

  def document_params
    params.require(:pg_search_document).permit(
      :slug,
      :position,
    )
  end
end
