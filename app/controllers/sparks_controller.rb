class SparksController < ApplicationController
  def index
  end

  def new
    @spark = Spark.new
  end

  def create
    @spark = Spark.create(params[:spark])
    @spark.save
    redirect_to root_path

  end



end
