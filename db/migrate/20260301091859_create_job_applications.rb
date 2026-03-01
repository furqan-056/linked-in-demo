class CreateJobApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :job_applications do |t|
      t.references :user, foreign_key: true
      t.references :job, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
