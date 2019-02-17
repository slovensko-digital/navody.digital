require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #show" do
    before do
      titles = ['Obciansky preukaz', 'Spider-man']
      titles.each do |title|
        draft_journey = create(:journey, title: title, published_status: 'DRAFT')
        published_journey = create(:journey, title: title, slug: "#{title} abc")
        create(:step, title: title, journey: draft_journey)
        create(:step, title: title, journey: published_journey, slug: "#{title} abc")
        create(:page, is_faq: false, title: title)
        create(:page, is_faq: true, title: title, slug: "#{title} abc")
      end
    end

    it "finds relevant public records" do
      get :show, params: { q: 'obciansky' }
      expect(assigns(:journeys).length).to eq 1
      expect(assigns(:steps).length).to eq 1
      expect(assigns(:pages).length).to eq 1
      expect(assigns(:count)).to eq 3
    end
  end

end
