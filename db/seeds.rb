# データベースに韻辞書を作成するため、S3に保管してあるCSVのソースを取得してwordsテーブルに格納する

require 'aws-sdk-s3'
require 'csv'

# AWSリソースを初期化
s3 = Aws::S3::Resource.new(region: 'ap-northeast-1')

# S3バケットを指定
bucket = s3.bucket('mecab-csv-import')

# S3バケット内のMecabーS3を指定
directory = 'Mecab-S3/'

# 処理対象のCSVファイルリスト
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

# エラーログを保存するための配列
error_logs = []

# S3バケット内のオブジェクトをループで処理
bucket.objects(prefix: directory).each do |object|

  # ファイル名を取得
  file_name = object.key.split('/').last

  # ファイル名が対象リストに含まれているか確認
  if target_files.include?(file_name)
    # S3からCSVファイルをダウンロードして読み込み
    csv_text = object.get.body.read

    # CSVデータをパース（ヘッダー付き、UTF-8エンコード）
    csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')

    # CSVの各行をループ
    csv.each_with_index do |row, index|
      begin

        #Wordモデルのインスタンスを作成し、データベースに保存
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

        # エラーが発生した場合エラーログに記録
        error_logs << "Failed to create word at row #{index + 2} in #{file_name}: #{e.message}"
      end
    end
  end
end

# 処理結果を出力
puts "All files have been processed."
puts "Total errors: #{error_logs.size}"
error_logs.each { |log| puts log }