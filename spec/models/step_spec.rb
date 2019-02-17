require 'rails_helper'

RSpec.describe Step, type: :model do

  let(:step) { build(:step) }

  subject { step }

  it { should be_valid }

  describe 'scope #published' do
    it 'returns record with published journey' do
      step.save!
      draft = create(:journey, published_status: 'DRAFT')
      create(:step, slug: 'abc', journey: draft)
      expect(Step.published).to eq [step]
    end
  end
end
