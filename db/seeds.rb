# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env == 'development'

  # Countries
  Country.destroy_all
  countries = ['Australia', 'Chile', 'United States', 'New Zealand', 'Peru']
  countries.sort { |a, b| a <=> b }.each do |country|
    Country.create!(name: country)
  end

  # Industries
  Industry.destroy_all
  industries = ['Beverage', 'Brewery', 'Dairy', 'Domestic Sewage', 'Energy', 'Food Processor',
                'Goverment', 'Grower', 'Milk Processor', 'Municipality', 'Real State',
                'Real State/Households/Hotels', 'Seafood Processor', 'Slaughterhouse',
                'University', 'Waste Management', 'Winery', 'WWT Provider']
  industries.sort { |a, b| a <=> b }.each do |industry|
    Industry.create!(name: industry)
  end

  # Discharge Points
  DischargePoint.destroy_all
  discharge_point = ['Irrigation', 'Stream', 'Land Application', 'Infiltration', 'Pond', 'Sewer', 'Other']
  discharge_point.sort { |a, b| a <=> b }.each do |point|
    DischargePoint.create!(name: point)
  end

  # Incident Types
  IncidentType.destroy_all
  incidents = ['ph Imbalance', 'Worms Mortality', 'Odors', 'Run off Chemicals', 'Flooding']
  incidents.each do |incident|
    IncidentType.create!(name: incident)
  end

  # Statuses
  Status.destroy_all
  statuses = ['Open', 'Fixed', 'Being Remedied']
  statuses.each do |status|
    Status.create!(name: status)
  end

  # Priorities
  Priority.destroy_all
  priorities = ['Within 24 Hours', 'Within 3 Days', 'Within 7 Days', 'Within 30 Days']
  priorities.each do |priority|
    Priority.create!(name: priority)
  end

  # Outlets
  Outlet.destroy_all
  outlets = %w[In Out]
  outlets.each do |outlet|
    Outlet.create!(name: outlet)
  end

  # Options
  Option.destroy_all
  options = ['Flow', 'Ph', 'Temp', 'EC', 'TDS', 'BOD', 'COD', 'TSS', 'FOG', 'TN', 'TKN',
             'Ammonia as N', 'Nitrate as N', 'Nitrite as N', 'TP', 'DO', 'Alkalinity as CaCo3',
             'Bicarbonate as CaCO3', 'Fecal Coliform', 'Foam Concentrate']
  options.each do |option|
    Option.create!(name: option)
  end

  puts 'Seeds Added!'
end
