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
      redirect_to @notes, notice: "Updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
