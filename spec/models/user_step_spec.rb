require 'rails_helper'

RSpec.describe UserStep, type: :model do
  describe 'scopes' do
    let!(:step1) { create(:step) }
    let!(:step2) { create(:step) }
    let!(:step3) { create(:step) }

    let!(:user_step2_old_done) { create(:user_step, step: step2, updated_at: 5.weeks.ago, status: 'done') }
    let!(:user_step2_old_started) { create(:user_step, step: step2, updated_at: 5.weeks.ago, status: 'started') }
    let!(:user_step2_old_started_with_recent_task) { create(:user_step, step: step2, updated_at: 5.weeks.ago, status: 'started') }
    let!(:user_task2) { create(:user_task, user_step: user_step2_old_started_with_recent_task, updated_at: 3.weeks.ago) }
    let!(:user_step2_recent_done) { create(:user_step, step: step2, updated_at: 3.weeks.ago, status: 'done') }
    let!(:user_step2_recent_waiting) { create(:user_step, step: step2, updated_at: 3.weeks.ago, status: 'waiting') }
    let!(:user_step2_recent_started) { create(:user_step, step: step2, updated_at: 3.weeks.ago, status: 'started') }
    let!(:user_step2_recent_not_started) { create(:user_step, step: step2, updated_at: 3.weeks.ago, status: 'not_started') }
    let!(:user_step3_recent_not_started) { create(:user_step, step: step3, updated_at: 3.weeks.ago, status: 'not_started') }
    let!(:user_step3_recent_done) { create(:user_step, step: step3, updated_at: 3.weeks.ago, status: 'done') }
    let!(:user_task3) { create(:user_task, user_step: user_step3_recent_done, updated_at: 1.day.ago) }

    describe '.recently_active' do
      subject(:tested_scope) { UserStep.recently_active }

      it 'Returns started but undone steps recently modified' do
        result = tested_scope

        expect(result).to contain_exactly(
                            user_step2_old_started_with_recent_task,
                            user_step2_recent_waiting,
                            user_step2_recent_started
                          )
      end
    end
  end
end
