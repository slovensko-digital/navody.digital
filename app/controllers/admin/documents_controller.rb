class Admin::DocumentsController < Admin::AdminController
  before_action :set_document, except: [:index, :reposition]

  # GET /admin/documents
  def index
    @documents = Document.featureable.includes(:searchable).order(featured: :desc, featured_position: :asc).select(&:searchable)
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

  def feature
    if @document.update(featured: true)
      redirect_back fallback_location: admin_documents_url, notice: 'Document was successfully updated.'
    end
  end

  def hide
    if @document.update(featured: false)
      redirect_back fallback_location: admin_documents_url, notice: 'Document was successfully updated.'
    end
  end

  def reposition
    Document.reposition_all
    redirect_to admin_documents_path, notice: 'Documents were successfully repositioned.'
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(
      :slug,
      :featured_position,
    )
  end
end
