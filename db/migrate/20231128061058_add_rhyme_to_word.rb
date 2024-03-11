class AddRhymeToWord < ActiveRecord::Migration[7.0]
  def change
    add_column :words, :rhyme, :string
  end
end
