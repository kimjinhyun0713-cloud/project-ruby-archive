class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    set_tag_search_data(Note)
    @notes = @items
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    # フォームから送られてきたデータ(post_params)でインスタンスを作る
    @note = Note.new(note_params)

    unless check_password_match?
      puts "[DEBUG] Doesnt match"
      flash.now[:alert] = "Password incorrect. Cannot create."
      # パスワード不一致なら保存せず、入力画面に戻す
      render :new, status: :unprocessable_entity
      return # ここで処理を終了
    end

    if @note.save
      # 成功したら詳細画面へリダイレクトし、メッセージを出す
      redirect_to @note, notice: "Created successfully!"
    else
      # 失敗したら、入力内容を保持したまま「新規作成画面」に戻す
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      redirect_to @note, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless check_password_match?
      redirect_to @note, alert: "Password incorrect. Cannot delete."
      return
    end
    @note.destroy

    redirect_to notes_path, notice: "Deleted successfully!", status: :see_other
  end

  private
    def set_note
      @note = Note.find(params[:id])
    end

    def note_params
      params.require(:note).permit(:title, :content, content_figures: [])
    end
end
