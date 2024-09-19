class CreateWordsNew < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string "surface_form"
      t.integer "left_context_id"
      t.integer "right_context_id"
      t.integer "cost"
      t.string "pos"
      t.string "pos_subcategory1"
      t.string "pos_subcategory2"
      t.string "pos_subcategory3"
      t.string "conjugation_form"
      t.string "conjugation_type"
      t.string "base_form"
      t.string "reading"
      t.string "pronunciation"

      t.timestamps
    end
  end
end