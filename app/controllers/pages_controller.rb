class PagesController < ApplicationController
  def index
    @metadata.og.title = 'Návody.Digital: Jednoduché návody na slovenské úrady'
    @metadata.og.description = 'Interaktívne návody, ako vybaviť úradné záležitosti elektronicky.'

    @faqs = Page.faq.all # TODO: fetch top FAQs here
    @journeys = Journey.published

    @blank_journeys = Journey.blank

  end

  def show
    @page = Page.find_by_slug!(params[:id])
  end
end
