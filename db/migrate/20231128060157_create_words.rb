class CreateWords < ActiveRecord::Migration[7.0]
  def change
    if Rails.env.production?
      create_table :words, primary_key: "wordid", id: :integer, force: :cascade do |t|
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
      end
    end
  end
end
