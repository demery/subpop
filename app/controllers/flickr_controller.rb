class FlickrController < ApplicationController
  include FlickrHelper

  before_action :get_item, only: [ :create, :show, :status, :create, :update, :destroy ]
  before_action :get_book, only: [ :create_book, :book_status, :update_book, :destroy_book ]

  def show
    authorize! :read, :flickr

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def status
    authorize! :read, :flickr

    respond_to do |format|
      format.js
      format.json
    end
  end

  def create_book
    authorize! :create, :flickr

    respond_to do |format|
      create_publish_jobs
      format.js
      format.html { redirect_to @book, notice: "Publishing all book images" }
    end
  end

  def update_book
    authorize! :update, :flickr

    respond_to do |format|
      create_publish_jobs
      format.js
      format.html { redirect_to @book, notice: "Publishing all book images" }
    end
  end

  def destroy_book
    authorize! :destroy, :flickr

    respond_to do |format|
      create_unpublish_jobs
      format.js
      format.html
    end
  end

  def book_status
    authorize! :read, :flickr

    respond_to do |format|
      format.js
      format.json
    end
  end

  def create
    authorize! :create, :flickr

    respond_to do |format|
      if @item.publishable?
        create_publish_jobs
        format.json { render json: @item }
        format.js
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
      else
        format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
        format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, :flickr

    respond_to do |format|
      if @item.publishable?
        create_publish_jobs
        format.js
        format.json { render json: @item }
        format.html { redirect_to @item, notice: "Publishing #{@item} to Flickr" }
      else
        format.html { redirect_to @item, notice: "#{@item} is up-to-date or already being published to Flickr" }
        format.json { render json: [ "#{@item} is up-to-date or already being published to Flickr" ], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, :flickr

    respond_to do |format|
      if @item.unpublishable?
        create_unpublish_jobs
        format.js
        format.json { render json: @item }
        format.html { redirect_to @item, notice: 'Removing photo from Flickr.' }
      else
        format.js   { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
        format.html { redirect_to @item, notice: 'Cannot remove photo from Flickr.' }
        format.json { render json: [ 'Item cannot be removed from Flickr.' ], status: :unprocessable_entity }
      end
    end
  end

  private

  def create_publish_jobs
    return enqueue_publish @item unless @item.is_a?(Book)

    # item is a book; enqueue each publishable
    @item.publishables.each { |item| enqueue_publish item }
  end

  def enqueue_publish item
    return unless item.publishable?

    item.mark_in_process
    return UpdateFlickrJob.perform_later item if item.on_flickr?
    AddToFlickrJob.perform_later item
  end

  def create_unpublish_jobs
    return enqueue_unpublish @item unless @item.is_a?(Book)

    # item is a book; add all unpublishable items
    @item.publishables.each { |item| enqueue_unpublish item }
  end

  def enqueue_unpublish item
    return unless item.unpublishable?

    item.mark_in_process
    RemoveFromFlickrJob.perform_later item
  end

  def get_book
    @book = @item = Book.find params[:id]
  end

  def get_item
    @item_type = params[:item_type]
    klass     = @item_type.camelize.constantize
    @item     = klass.find params[:id]
  end
end
