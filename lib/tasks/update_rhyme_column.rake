namespace :db do
  desc "S3からデータを取得してデータベースにシードし、その後rhymeカラムを更新する"
  task seed_and_update_rhymes: :environment do
    Rake::Task['db:seed'].invoke
    Rake::Task['db:migrate'].invoke
    Word.update_rhymes
  end
end

namespace :word do
  desc "rhymeカラムの更新のみ"
  task update_rhymes: :environment do
    Word.update_rhymes
  end
end


#rails db:seed_and_update_rhymes

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
