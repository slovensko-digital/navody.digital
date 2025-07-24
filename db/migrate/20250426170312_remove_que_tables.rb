class RemoveQueTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :que_values, if_exists: true, force: :cascade
    drop_table :que_lockers, if_exists: true, force: :cascade
    drop_table :que_jobs, if_exists: true, force: :cascade
    execute "DROP FUNCTION IF EXISTS que_job_notify"
    execute "DROP FUNCTION IF EXISTS que_validate_tags"
    execute "DROP FUNCTION IF EXISTS que_determine_job_state"
    execute "DROP FUNCTION IF EXISTS que_state_notify"
  end

  def down
  end
end
