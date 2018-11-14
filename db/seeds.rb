# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env == 'development'

  # Countries
  Country.destroy_all
  countries = ['Australia', 'Chile', 'United States', 'New Zealand', 'Peru']

  countries.sort { |a, b| a <=> b }.each do |country|
    Country.create!(name: country)
  end

  industries = ['Beverage', 'Brewery', 'Dairy', 'Domestic Sewage', 'Energy', 'Food Processor', 'Goverment', 'Grower', 'Milk Processor', 'Municipality', 'Real State', 'Real State/Households/Hotels', 'Seafood Processor', 'Slaughterhouse', 'University', 'Waste Management', 'Winery', 'WWT Provider']
  industries.sort { |a, b| a <=> b }.each do |industry|
    Industry.create!(name: industry)
  end

  discharge_point = ['Irrigation', 'Stream', 'Land Application', 'Infiltration', 'Pond', 'Sewer', 'Other']
  discharge_point.sort { |a, b| a <=> b }.each do |point|
    DischargePoint.create!(name: point)
  end

end
