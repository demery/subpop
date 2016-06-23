class TitlePagesController < ApplicationController
  before_action :set_title_page,  only: [ :show, :destroy ]
  before_action :set_book,        only: [ :create, :destroy ]
  before_action :set_photo,       only: :create
  authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to @book, :alert => exception.message }
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to @title_page.book }
    end
  end

  def create
    @title_page = TitlePage.new book: @book, photo: @photo

    respond_to do |format|
      if @title_page.save_by current_user
        @title_page.dequeue_photo
        format.html { redirect_to @book, notice: 'Added title page.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { redirect_to @book, notice: 'Error adding title page' }
        format.json { redirect_to json: @title_page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @title_page.requeue_photo
    @title_page.mark_deleted
    DeletePublishableJob.perform_later @title_page
    respond_to do |format|
      format.js
      format.html { redirect_to @book, notice: 'Title page was removed.' }
    end
  end

  private

  def set_title_page
    @title_page = TitlePage.find params[:id]
  end

  def set_book
    @book = Book.find params[:book_id]
  end

  def set_photo
    @photo = Photo.find params[:photo_id]
  end
end
