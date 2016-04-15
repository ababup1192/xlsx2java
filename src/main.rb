# require 'active_support/all'
require 'roo'
require 'json'

# xlsxではなくxlsファイルを使う時はExcelx -> Excelに変更する
excel = Roo::Excelx.new("./excel/sample.xlsx")

excel.sheets.each{ |sheet|
  excel.default_sheet = sheet

  # テーブル情報を読み取り中かどうかを表す
  searching = false
  rowjson = []

  # embedded対象のシートとテーブル情報を保持する配列
  embeddedHash = {}

  for i in 1..excel.last_row do
    # flag初期化
    flagUserId = false
    flagUserPassword = false
    flagUpdate = false
    flagEmbedded = false

    # 「No.」という要素の行がみつかったらその次の行から列の内容を順番にJSON形式に合わせて記録していく
    if searching == false && excel.cell(i, 2) == "No." then
      # シートの名前を記録
      sheetName = excel.cell(1,1)
      # テーブルの名前を記録
      tableName = excel.cell(i - 1, 6)
      # モデルの名前を記録
      modelName = excel.cell(i - 2, 6)

      searching = true
    # 現在の行のテーブル情報をJSONとして記録
    elsif searching == true then
      # アノテーションの列の内容を読み取り
      if excel.cell(i, 11) != '-' then
        excel.cell(i, 11).split(",").each { |annotation|
          flagUserId = true if annotation == "UserId"
          flagUserPassword = true if annotation == "UserPassword"
          flagUpdate = true if annotation == "Update"
          flagEmbedded = true if annotation == "Embedded"
        }
      end

      # リンクの列の内容を読み取り
      if flagEmbedded == true then
        embeddedHash[excel.cell(i, 12).scan(/(.+)!(.+)/).flatten.first] = excel.cell(i, 12).scan(/(.+)!(.+)/).flatten.last
      end

      rowjson.push(
        {
          :variableName => excel.cell(i, 4),
          :columnName => excel.cell(i, 5),
          :type => excel.cell(i, 6),
          :integralDigits => if excel.cell(i, 7) == "-" then false else excel.cell(i, 7) end,
          :decimalDigits => if excel.cell(i, 8) == "-" then false else excel.cell(i, 8) end,
          :primary => if excel.cell(i, 10) == "-" then false else true end,
          :search => if excel.cell(i, 10) == "-" then false else true end,
          :userId => if flagUserId == true then true else false end,
          :userPassword => if flagUserPassword == true then true else false end,
          :update => if flagUpdate == true then true else false end,
          :embedded => if flagEmbedded == true then true else false end
        }
      )

      # 次の行が各テーブル定義の境界の空白行だったら今までの行のデータを出力して終了
      if excel.cell(i + 1, 2) == nil then
        jsondata = {
          :sheetName => sheetName,
          :tableName => tableName,
          :modelName => modelName,
          # TODO embedded判定
          :linked => false,
          :data => rowjson
        }

        puts JSON.pretty_generate(jsondata)
        searching = false
      end
    end
  end
}
