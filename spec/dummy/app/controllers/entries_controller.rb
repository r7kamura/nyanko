class EntriesController < ApplicationController
  def index
    @entries = Entry.all
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def new
    @entry = Entry.new
    render :edit
  end

  def create
    @entry = Entry.create(params[:entry])
    redirect_to @entry
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update_attributes(params[:entry])
    redirect_to @entry
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_path
  end
end
