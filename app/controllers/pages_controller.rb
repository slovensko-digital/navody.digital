class PagesController < ApplicationController
  def index
    @metadata.og.title = 'Návody.Digital: Jednoduché návody na slovenské úrady'
    @metadata.og.description = 'Interaktívne návody, ako vybaviť úradné záležitosti elektronicky.'

    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @documents = PgSearch::Document.featured_on_front_page.includes(:searchable).map(&:searchable).compact # we do not have FK constraints here, compact eliminates any possible documents hanging without searchable counterpart, which was deleted
  end

  def show
    @page = Page.find_by_slug!(params[:id])
  end
end
