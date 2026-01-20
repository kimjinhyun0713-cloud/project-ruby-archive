# lib/tasks/openai_test.rake
namespace :openai do
  desc "OpenAIとの接続テストを行うタスク"
  task test: :environment do
    puts "📡 OpenAIに接続テスト中..."

    begin
      # サービスの呼び出し
      client = OpenaiClient.new
      start_time = Time.now

      # テスト用の質問
      result = client.generate_text("Railsエンジニアに一言励ましの言葉をください。")

      duration = (Time.now - start_time).round(2)

      puts "----------------------------------------"
      puts "✅ 接続成功！ (#{duration}秒)"
      puts "🤖 AIからの返答:"
      puts result
      puts "----------------------------------------"

    rescue => e
      puts "----------------------------------------"
      puts "❌ エラーが発生しました"
      puts "エラー内容: #{e.message}"
      puts "----------------------------------------"
    end
  end


  desc "単語リストから完璧な文章を作るテスト"
  task sentence: :environment do
    input = "同一性：identity -> 同じaddress 等価性：equality -> valueが同じ interning：等価なimmutable objectを一つだけ維持する。"
    puts "📡 文章生成を開始します..."
    puts "入力単語: #{input}"
    result = make_sentence_in_rake(input)
    puts "----------------------------------------"
    puts "🤖 生成された文章:"
    puts result
    puts "----------------------------------------"
  end

  # Rakeファイル内で使うメソッド定義
  # ※他の場所と名前が被らないように少し名前を変えています
  def make_sentence_in_rake(input_sentence)
    # 【重要】ここではServiceクラスではなく、直接Gemのクライアントを使う
    # (もしくは OpenaiClientに attr_reader :client が必要)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])

    prompt = <<~TEXT
      以下のinputをすべて使用して、文脈が通る自然で完璧な日本語の文章を作成してください。
      単語の順番は入れ替えても構いません。助詞（て・に・を・は）は適切に補ってください。
      敬語で出力してください。
      input: #{input_sentence}
    TEXT

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "あなたはプロのライターです。..." },
          { role: "user", content: prompt }
        ],
        temperature: 0.3
      }
    )

    response.dig("choices", 0, "message", "content")
  end
end
