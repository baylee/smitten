class SparksController < ApplicationController
  def index
  end

  def new
    @spark = Spark.new
  end

  def create
    binding.pry
    @spark = Spark.create(params[:spark])
    @spark.save
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end

  end



end
