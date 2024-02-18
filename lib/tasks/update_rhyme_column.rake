namespace :db do
  desc "wordsテーブルのrhymeカラムを更新する"
  task update_rhymes: :environment do
    Word.update_rhymes
  end
end

#rake db:update_rhymes

#csvインポート

# COPY words(
# surface_form,
# left_context_id,
# right_context_id,
# cost,
# pos,
# pos_subcategory1,
# pos_subcategory2,
# pos_subcategory3,
# conjugation_form,
# conjugation_type,
# base_form,
# reading,
# pronunciation
# ) FROM ".csv" DELIMITER ',' CSV;
