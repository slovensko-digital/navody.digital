require 'rails_helper'

RSpec.describe NotificationSubscription, type: :model do
  describe '#confirm' do
    context 'is not confirmed' do
      it 'sets confirmed and saves' do
        ns = build(:notification_subscription, confirmed_at: nil)
        expect{
          ns.confirm
        }.to change(described_class, :count).by(1)
        expect(ns.reload.confirmed_at).not_to be_nil
      end
    end

    context 'is confirmed' do
      it 'preserves date' do
        confirmed_at = DateTime.new(2018,1,1)
        ns = build(:notification_subscription, confirmed_at: confirmed_at)
        expect{
          ns.confirm
        }.to change(described_class, :count).by(1)
        expect(ns.reload.confirmed_at.to_date).to eq confirmed_at.to_date
      end
    end

    context 'type list exists in TYPES' do
      context 'user is assigned to listing' do
        it 'uses user email' do
          expect(SubscribeToNewsletterJob).to receive(:perform_later).with('peter@example.com', 'NewsletterSubscription')
          ns = build(:notification_subscription, type: 'NewsletterSubscription', user: create(:user, email: 'peter@example.com'))
          ns.confirm
        end
      end

      context 'anonymous user' do
        it 'uses email' do
          expect(SubscribeToNewsletterJob).to receive(:perform_later).with('andrej@example.com', 'NewsletterSubscription')
          ns = build(:notification_subscription, type: 'NewsletterSubscription', email: 'andrej@example.com')
          ns.confirm
        end
      end
    end
  end
end
