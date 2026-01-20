class TranslatorsController < ApplicationController
  def create
    prompt = params[:prompt]
    language = params[:language]
    persona = params[:persona]
    puts "\n" + "="*30
    puts " [DEBUG] Language: #{language}"
    puts " [DEBUG] Persona:  #{persona}"
    puts "="*30 + "\n"

    client = OpenaiClient.new
    result = client.generate_text(prompt, language: language, persona: persona)
    
    # render partial を使い、部品だけを更新して返す
    render partial: "shared/translator_sidebar", locals: { 
      result: result, 
      prompt: prompt, 
      language: language,
      persona: persona
    }
  end
end