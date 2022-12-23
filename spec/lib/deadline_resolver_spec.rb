require 'spec_helper'

RSpec.describe DeadlineResolver do
  describe '#is_past_due?' do
    context 'when non-recurring deadline is set' do
      it 'reports truthy for a passed deadline' do
        klass = described_class.new('2022-03-01', Date.new(2022, 3, 10))
        expect(klass.is_past_due?).to be_truthy
      end

      it 'reports falsey for an upcoming deadline' do
        klass = described_class.new('2022-03-01', Date.new(2022, 2, 10))
        expect(klass.is_past_due?).to be_falsey
      end
    end

    context 'when recurring deadline is set' do
      it 'reports truthy for a recently passed deadline' do
        klass = described_class.new('03-01', Date.new(2022, 3, 10))
        expect(klass.is_past_due?).to be_truthy
      end

      it 'reports falsey for an upcoming deadline due next year' do
        klass = described_class.new('03-01', Date.new(2022, 12, 22))
        expect(klass.is_past_due?).to be_falsey
      end
    end
  end
end
