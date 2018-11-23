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

  incidents = ['ph Imbalance', 'Worms Mortality', 'Odors', 'Run off Chemicals', 'Flooding']
  incidents.each do |incident|
    IncidentType.create!(name: incident)
  end

  statuses = ['Open', 'Fixed', 'Being Remedied']
  statuses.each do |status|
    Status.create!(name: status)
  end

  priorities = ['Within 24 Hours', 'Within 3 Days', 'Within 7 Days', 'Within 30 Days']
  priorities.each do |priority|
    Priority.create!(name: priority)
  end

  puts 'Added Seeds!'
end
