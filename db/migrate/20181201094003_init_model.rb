class InitModel < ActiveRecord::Migration[5.2]
  def change
    create_table :journeys do |t|
      t.text :title, null: false
      t.text :keywords
      t.text :published_status, null: false
      t.string :slug, null: false, unique: true
      t.timestamps
    end

    create_table :steps do |t|
      t.belongs_to :journey, null: false
      t.text :title, null: false
      t.text :keywords
      t.boolean :is_waiting_step, null: false, default: false
      t.string :slug, null: false, unique: true
      t.timestamps
    end

    add_foreign_key :steps, :journeys

    create_table :tasks do |t|
      t.belongs_to :step, null: false
      t.text :title, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_foreign_key :tasks, :steps

    create_table :users do |t|
      t.text :email, null: false
      t.timestamps
    end

    create_table :user_journeys do |t|
      t.belongs_to :user, null: false
      t.belongs_to :journey, null: false
      t.datetime :started_at, null: false
      t.timestamps
    end

    add_foreign_key :user_journeys, :users
    add_foreign_key :user_journeys, :journeys

    create_table :user_steps do |t|
      t.belongs_to :user_journey, null: false
      t.belongs_to :step, null: false
      t.string :status, null: false
      t.timestamps
    end

    add_foreign_key :user_steps, :user_journeys, column: :user_journey_id
    add_foreign_key :user_steps, :steps

    create_table :user_tasks do |t|
      t.belongs_to :user_step, null: false
      t.belongs_to :task, null: false
      t.datetime :completed_at
      t.timestamps
    end

    add_foreign_key :user_tasks, :user_steps, column: :user_step_id
    add_foreign_key :user_tasks, :tasks

    create_table :pages do |t|
      t.text :title, null: false, unique: true
      t.text :content, null: false
      t.text :slug, null: false, unique: true
      t.boolean :is_faq, null: false, default: false
      t.timestamps
    end
  end
end
