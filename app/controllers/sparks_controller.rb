class SparksController < ApplicationController
  def show
    @spark = Spark.find(params[:id])
  end

  def new
    @spark = Spark.new
  end

  def create
    @spark = Spark.new(params[:spark])

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

  def update_location
    @spark = Spark.new(:latitude => params[:latitude], :longitude => params[:longitude], :location_only => true, :user_id => current_user.id)

    respond_to do |format|
      if @spark.save
        @nearby_sparks = current_user.relevant_sparks
        format.html { redirect_to root_path, notice: 'Spark has been sent! YAY!'}
        format.js
      else
        format.html { redirect_to new_spark_path, :alert => 'Spark failed. You must first allow your location to be shared.' }
        format.js
      end
    end

  end


  def places
    # @nearby_sparks = current_user.relevant_sparks
    @my_locations = current_user.places_ive_been
  end

  def edit
    @spark = Spark.find(params[:id])
    if @spark.user_id != current_user.id
      redirect_to spark_path(@spark), :alert => "You do not have access to edit that spark."
    end
  end

  def update
    @spark = Spark.find(params[:id])

    respond_to do |format|
      if @spark.update_attributes(params[:spark])
        format.html { redirect_to spark_path(@spark), notice: 'Spark has successfully updated.'}
        format.js
      else
        format.html { redirect_to spark_path(@spark), :alert => 'Spark update failed.' }
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
