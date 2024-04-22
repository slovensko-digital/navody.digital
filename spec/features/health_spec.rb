require 'rails_helper'

RSpec.feature "Healthcheck", type: :feature do
  context 'when healthcheck passes' do
    scenario 'With healthcheck I want to check if everything is ok' do
      visit health_path

      expect(page.status_code).to be(200)

      returned_data = JSON.parse(page.body)

      expect(returned_data["status"]).to eq("ok")
    end
  end

  context 'when healthcheck fails' do
    scenario 'unexpected error in health check' do
      allow_any_instance_of(HealthController).to receive(:all_database_healthy?).and_raise(StandardError, 'Unexpected error')

      visit health_path

      expect(page.status_code).to be(500)
      returned_data = JSON.parse(page.body)

      expect(returned_data["status"]).to eq("fail")
    end

    scenario 'primary database fails' do
      allow(ApplicationRecord.connection).to receive(:execute).and_raise(StandardError, 'Something went wrong in primary db')

      visit health_path

      expect(page.status_code).to be(500)
      returned_data = JSON.parse(page.body)

      expect(returned_data["status"]).to eq("fail")
    end

    scenario 'datahub database fails' do
      allow(DatahubRecord.connection).to receive(:execute).and_raise(StandardError, 'Something went wrong in datahub db')

      visit health_path

      expect(page.status_code).to be(500)
      returned_data = JSON.parse(page.body)

      expect(returned_data["status"]).to eq("fail")
    end
  end
end
