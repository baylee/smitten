class SparksController < ApplicationController
  def show
    @spark = Spark.find(params[:id])
  end

  def new
    @spark = Spark.new
  end

  def create
    @spark = Spark.create(params[:spark])

    respond_to do |format|
      if @spark.save
        format.html { redirect_to root_path, notice: 'Spark has been sent! YAY!'}
        format.js
      else
        format.html { redirect_to new_spark_path, :alert => 'Spark failed. You must first allow your location to be shared.' }
        format.js
      end
    end
  end

  def destroy
    @spark = Spark.find(params[:id])
    @spark.destroy

    respond_to do |format|
      format.html { redirect_to profile_path }
      format.js
    end
  end


end
