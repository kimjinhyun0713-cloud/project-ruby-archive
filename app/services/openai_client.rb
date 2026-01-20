# app/services/openai_client.rb
class OpenaiClient
  require 'openai'

  # 言語設定
  LANGUAGE_LABELS = {
    "japanese" => "日本語",
    "korean"   => "韓国語",
    "english"  => "英語"
  }.freeze

  PERSONA_SETTINGS = {
    "writer" => {
      temperature: 0.3,
      max_tokens: 300,
      instruction: <<~TEXT
        必ず%{language}で作成してください。
        あなたはプロのライター兼編集者です。
        Websiteや新聞記事に載せされるように文章を書き直します。
        ユーザーから渡されたテキスト（input）に対して、以下のルールで処理を行い、結果のみを出力してください。        
        【処理ルール】
        1. 文法を修正し、論理的に破綻がないようリライトしてください。
        2. 単語の羅列の場合、それらを全て使用し、文脈が通る自然で完璧な文章を作成してください。        
        【制約】
        - 丁寧な敬語（です・ます調）で出力すること。
        - 余計な前置きは不要です。
      TEXT
    },

    "summary" => {
      temperature: 0.1, # 創造性を極力排除して事実に忠実に
      max_tokens: 300,  # 長くなりすぎないように制限
      instruction: <<~TEXT
        必ず%{language}で作成してください。
        あなたは優秀な要約アシスタントです。
        ユーザーから渡されたテキスト（input）の要点を抽出し、簡潔で分かりやすい要約文を作成してください。
        【制約】
        - 重要な事実や数字は漏らさないこと。
        - 箇条書きを適宜使用して可読性を高めること。
        - 主観や感想は入れず、客観的な事実のみを記述すること。
      TEXT
    },

    "advisor" => {
      temperature: 0.7, # 少し値を上げて、多様な視点や柔軟な表現を許容する
      max_tokens: 500,  # アドバイスは詳細な方が良いため長めに
      instruction: <<~TEXT
        必ず%{language}で作成してください。
        あなたは経験豊富で親身なメンター・アドバイザーです。        
        ユーザーから渡された悩みや相談（input）に対して、具体的かつ前向きなアドバイスをしてください。
        【行動指針】
        - ユーザーの感情に寄り添い、共感を示してください。
        - 単なる正論だけでなく、実行可能な「次のアクション」を提案してください。
        - 語り口は柔らかく、励ますようなトーンで話してください。
      TEXT
    }
  }.freeze

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  # persona引数を追加（デフォルトはwriter）
  def generate_text(prompt, language: "japanese", persona: "writer")
    target_language = LANGUAGE_LABELS.fetch(language, "日本語")
    settings = PERSONA_SETTINGS.fetch(persona, PERSONA_SETTINGS["writer"])
    system_message = settings[:instruction] % { language: target_language }
    puts target_language
    puts settings

    user_input_message = "#{prompt} 必ず答えを#{language}で作成"

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: system_message },
          { role: "user", content: user_input_message }
        ],
        # ペルソナごとのパラメータを適用
        temperature: settings[:temperature], 
        max_tokens: settings[:max_tokens]
      }
    )
    
    response.dig("choices", 0, "message", "content")
  end

  def content_summary(text, language: "japanese")
    if text.to_s.length > 50
      generate_text(text, language: language, persona: "summary")
    else
      "Too short to summarize"
    end
  end
end