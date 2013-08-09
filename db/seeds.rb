# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



  #sparks :content, :latitude, :longitude, :user_id


  #girls
  susan = User.find_by_email("mylgvxt_seligsteinsen_1376089394@tfbnw.net")
  sandra = User.find_by_email("faycpnu_narayanansky_1376089384@tfbnw.net")
  #boys
  tom = User.find_by_email("mztwxwx_thurnescuwitzsensteinskymanbergson_1376089389@tfbnw.net")
  will = User.find_by_email("jcjdumi_chaiman_1376089402@tfbnw.net")
  joe = User.find_by_email("pxoozsy_schrockescu_1376089396@tfbnw.net")
  dick = User.find_by_email("imktrlv_carrierobergwitzskysensteinmanescuson_1376089391@tfbnw.net")

  #joe's spark when he saw tom
  Spark.create(:content => "Saw a beautiful man with dreamy eyes. You were holding a big burrito.", :user_id => joe.id, :latitude => 37.809089658172, :longitude => -122.47270142897)

  #susan's spark when she saw will
  Spark.create(
    :content => "You bumped into me and said sorry in a husky voice. Lets meet up for coffee?",
    :user_id => susan.id,
    :latitude =>  37.787301917136,
    :longitude => -122.40788953118)

  #will's spark for susan

  Spark.create(
    :content => "You have a great caboose and I bumped into it. I said sorry.",
    :user_id => will.id,
    :latitude =>  37.787301917136,
    :longitude => -122.40788953118)





