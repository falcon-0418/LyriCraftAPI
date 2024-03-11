require 'aws-sdk-s3'
require 'csv'

s3 = Aws::S3::Resource.new(region: 'ap-northeast-1')
bucket = s3.bucket('mecab-csv')

directory = 'Mecab-S3/'
target_files = [
  'Adj.csv',
  'Adnominal.csv',
  'Adverb.csv',
  'Noun.adverbal.csv',
  'Noun.verbal.csv',
  'Noun.adjv.csv',
  'Noun.csv',
  'neologd-noun-sahen-conn-ortho-variant-dict-seed.20160323.csv',
  'neologd-adjective-verb-dict-seed.20160324.csv'
]

error_logs = []

bucket.objects(prefix: directory).each do |object|
  file_name = object.key.split('/').last
  if target_files.include?(file_name)
    csv_text = object.get.body.read
    csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')

    csv.each_with_index do |row, index|
      begin
        Word.create!({
          surface_form: row['surface_form'],
          left_context_id: row['left_context_id'],
          right_context_id: row['right_context_id'],
          cost: row['cost'],
          pos: row['pos'],
          pos_subcategory1: row['pos_subcategory1'],
          pos_subcategory2: row['pos_subcategory2'],
          pos_subcategory3: row['pos_subcategory3'],
          conjugation_form: row['conjugation_form'],
          conjugation_type: row['conjugation_type'],
          base_form: row['base_form'],
          reading: row['reading'],
          pronunciation: row['pronunciation']
        })
      rescue => e
        error_logs << "Failed to create word at row #{index + 2} in #{file_name}: #{e.message}"
      end
    end
  end
end

puts "All files have been processed."
puts "Total errors: #{error_logs.size}"
error_logs.each { |log| puts log }