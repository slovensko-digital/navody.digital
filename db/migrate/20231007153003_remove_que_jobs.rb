class RemoveQueJobs < ActiveRecord::Migration[7.0]
  def up
    drop_table :que_jobs, force: :cascade, if_exists: true
    drop_table :que_values, force: :cascade, if_exists: true
    drop_table :que_lockers, force: :cascade, if_exists: true

    execute 'DROP FUNCTION IF EXISTS que_validate_tags CASCADE'
    execute 'DROP FUNCTION IF EXISTS que_state_notify CASCADE'
    execute 'DROP FUNCTION IF EXISTS que_job_notify CASCADE'
  end
end
