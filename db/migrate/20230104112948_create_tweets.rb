class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :text
      t.string :media_url
      t.string :type
      t.datetime :tweeted_at

      t.timestamps
    end
  end
end
