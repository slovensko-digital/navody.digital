class PagesController < ApplicationController
  def index
    @metadata.og.title = 'Návody.Digital: Jednoduché návody na slovenské úrady'
    @metadata.og.description = 'Interaktívne návody, ako vybaviť úradné záležitosti elektronicky.'

    @faqs = Page.faq.order(position: :asc).all
    @categories = Category.featured.order(featured_position: :asc, name: :asc)
    @documents = Document.featured.includes(:searchable).order(featured_position: :asc).map(&:searchable).compact # we do not have FK constraints here, compact eliminates any possible documents hanging without searchable counterpart, which was deleted
  end

  def show
    @page = Page.find_by_slug!(params[:id])

    @metadata.og.image = @page.image_name.presence || "placeholder.png"
  end
end
