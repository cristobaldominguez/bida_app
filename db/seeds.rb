puts '----------- Adding Seeds! -----------'

# Users
puts 'Adding Users'
User.destroy_all
roles = %i[no_role admin client operator operations_manager viewer]
users = [{ name: 'Cristóbal', lastname: 'Domínguez', email: 'cristobald@me.com', password: 'golden', role: :admin },
         { name: 'Matías', lastname: 'Sjogren', email: 'msjogren@bf.com', password: '123123', role: :admin },
         { name: 'Ricardo', lastname: 'Aburto', email: 'raburto@bf.com', password: '123123', role: :operations_manager },
         { name: 'Francisco', lastname: 'Del Toro', email: 'fdeltoro@bf.com', password: '123123', role: :operator },
         { name: 'Ellen', lastname: 'Sanders', email: 'ellen.sanders@example.com', password: '123123', role: roles.sample },
         { name: 'Lester', lastname: 'Murray', email: 'lester.murray@example.com', password: '123123', role: roles.sample },
         { name: 'Vicki', lastname: 'Hunter', email: 'vicki.hunter@example.com', password: '123123', role: roles.sample },
         { name: 'Frank', lastname: 'Horton', email: 'frank.horton@example.com', password: '123123', role: roles.sample },
         { name: 'Jorge', lastname: 'Berry', email: 'jorge.berry@example.com', password: '123123', role: roles.sample },
         { name: 'Ethan', lastname: 'Fletcher', email: 'ethan.fletcher@example.com', password: '123123', role: roles.sample },
         { name: 'Jane', lastname: 'Hansen', email: 'jane.hansen@example.com', password: '123123', role: roles.sample },
         { name: 'Leonard', lastname: 'Crawford', email: 'leonard.crawford@example.com', password: '123123', role: roles.sample }]
users.each do |user|
  u = User.create!(name: user[:name], lastname: user[:lastname], email: user[:email], password: user[:password], role: user[:role])
  puts "- #{u.full_name} was added"
end

# Metric Types
puts 'Adding Metric Types'
MetricType.destroy_all
metric_types = %i[Imperial Metric]
metric_types.each do |metric_type|
  MetricType.create!(option: metric_type)
end

# Metrics
puts 'Adding Metrics'
Metric.destroy_all
metric_types = MetricType.all
metrics_final = {}
metrics = { Imperial: { length: 'Feet', volume: 'Gallon', area: 'Square Foot', mass: 'Pounds', temperature: 'Fahrenheit' },
            Metric: { length: 'Meters', volume: 'Liter', area: 'Square Meter', mass: 'Kilogram', temperature: 'Celsius' } }
metrics.each do |k, metric|
  metric_type = metric_types.find_by(option: k.to_s)
  metrics_final[k.to_sym] = metric_type.metrics.create!(length: metric[:length], volume: metric[:volume], area: metric[:area], mass: metric[:mass], temperature: metric[:temperature])
end

# Countries
puts 'Adding Countries'
Country.destroy_all
countries = [{ name: 'Australia', metric: metrics_final[:Metric] },
             { name: 'Chile', metric: metrics_final[:Metric] },
             { name: 'United States', metric: metrics_final[:Imperial] },
             { name: 'New Zealand', metric: metrics_final[:Metric] },
             { name: 'Peru', metric: metrics_final[:Metric] }]
countries.each do |country|
  Country.create!(name: country[:name], metric: country[:metric])
end

# Industries
puts 'Adding Industries'
Industry.destroy_all
industries = ['Beverage', 'Brewery', 'Dairy', 'Domestic Sewage', 'Energy', 'Food Processor',
              'Government', 'Grower', 'Milk Processor', 'Municipality', 'Real State',
              'Real State/Households/Hotels', 'Seafood Processor', 'Slaughterhouse',
              'University', 'Waste Management', 'Winery', 'WWT Provider']
industries.sort { |a, b| a <=> b }.each do |industry|
  Industry.create!(name: industry)
end

# Discharge Points
puts 'Adding Discharge Points'
DischargePoint.destroy_all
discharge_point = ['Irrigation', 'Stream', 'Land Application', 'Infiltration', 'Pond', 'Sewer', 'Other']
discharge_point.sort { |a, b| a <=> b }.each do |point|
  DischargePoint.create!(name: point)
end

# Incident Types
puts 'Adding Incident Types'
IncidentType.destroy_all
incidents = ['ph Imbalance', 'Worms Mortality', 'Odors', 'Run off Chemicals', 'Flooding']
incidents.each do |incident|
  IncidentType.create!(name: incident)
end

# Statuses
puts 'Adding Statuses'
Status.destroy_all
statuses = ['Open', 'Fixed', 'Being Remedied']
statuses.each do |status|
  Status.create!(name: status)
end

# Priorities
puts 'Adding Priorities'
Priority.destroy_all
priorities = ['Within 24 Hours', 'Within 3 Days', 'Within 7 Days', 'Within 30 Days']
priorities.each do |priority|
  Priority.create!(name: priority)
end

# Outlets
puts 'Adding Outlets'
Outlet.destroy_all
outlets = %w[In Out]
outlets.each do |outlet|
  Outlet.create!(name: outlet)
end

# Options
puts 'Adding Options'
Option.destroy_all
options = ['Flow', 'Ph', 'Temp', 'EC', 'TDS', 'BOD', 'COD', 'TSS', 'FOG', 'TN', 'TKN',
           'Ammonia as N', 'Nitrate as N', 'Nitrite as N', 'TP', 'DO', 'Alkalinity as CaCo3',
           'Bicarbonate as CaCO3', 'Fecal Coliform', 'Foam Concentrate']
options.each do |option|
  Option.create!(name: option)
end

# Accesses
puts 'Adding Accesses'
Access.destroy_all
accesses = %w[Lab Internal]
accesses.each do |access|
  Access.create!(name: access)
end

# Frecuencies
puts 'Adding Frecuencies'
Frecuency.destroy_all
frecuencies = %w[Daily Weekly Monthly Annualy]
frecuencies.each do |frecuency|
  Frecuency.create!(name: frecuency)
end

# Odors
puts 'Adding Odors'
Odor.destroy_all
odors = ['Typical', 'No Typical (Describe)']
odors.each do |odor|
  Odor.create!(option: odor)
end

# Colors
puts 'Adding Colors'
Color.destroy_all
colors = ['Typical', 'No Typical (Describe)']
colors.each do |color|
  Color.create!(option: color)
end

# Screens
puts 'Adding Screens'
Screen.destroy_all
screens = ['Normal', 'Clogged', 'Film has Formed']
screens.each do |screen|
  Screen.create!(option: screen)
end

# Collection Bins
puts 'Adding Collection Bins'
CollectionBin.destroy_all
collection_bins = %w[Normal Full Spillage]
collection_bins.each do |collection_bin|
  CollectionBin.create!(option: collection_bin)
end

# Noises
puts 'Adding Noises'
Noise.destroy_all
noises = ['Normal', 'Unnormal (Describe)']
noises.each do |noise|
  Noise.create!(option: noise)
end

# Sprinklers Pressures
puts 'Adding Sprinklers Pressures'
SprinklersPressure.destroy_all
sprinklers_pressures = %w[Low Normal High]
sprinklers_pressures.each do |pressure|
  SprinklersPressure.create!(option: pressure)
end

# Sprinklers Heads
puts 'Adding Sprinklers Heads'
SprinklersHead.destroy_all
sprinklers_heads = %w[Normal Clogged Missing]
sprinklers_heads.each do |head|
  SprinklersHead.create!(option: head)
end

# Pipings
puts 'Adding Pipings'
Piping.destroy_all
pipings = %w[Normal Leaking Broken]
pipings.each do |piping|
  Piping.create!(option: piping)
end

# System Surfaces
puts 'Adding System Surfaces'
SystemSurface.destroy_all
system_surfaces = ['Normal', 'Vegetation Growing', 'Trash']
system_surfaces.each do |surface|
  SystemSurface.create!(option: surface)
end

# Worms Colors
puts 'Adding Worms Colors'
WormsColor.destroy_all
worms_colors = ['Normal', 'Unnormal (Describe)']
worms_colors.each do |color|
  WormsColor.create!(option: color)
end

# Worms Activities
puts 'Adding Worms Activities'
WormsActivity.destroy_all
worms_activities = ['Active', 'No Active (Describe)']
worms_activities.each do |activity|
  WormsActivity.create!(option: activity)
end

# Worms Densities
puts 'Adding Worms Densities'
WormsDensity.destroy_all
worms_densities = %w[Low Normal High]
worms_densities.each do |activity|
  WormsDensity.create!(option: activity)
end

# Bed Compactions
puts 'Adding Bed Compactions'
BedCompaction.destroy_all
bed_compactions = ['Normal', 'Compaction (Need Rototill)']
bed_compactions.each do |compaction|
  BedCompaction.create!(option: compaction)
end

# Pondings
puts 'Adding Pondings'
Ponding.destroy_all
pondings = ['No Ponding', 'High Ponding (Urgent Rototill)']
pondings.each do |ponding|
  Ponding.create!(option: ponding)
end

# Flies
puts 'Adding Flies'
Fly.destroy_all
flies = %w[No Low High]
flies.each do |fly|
  Fly.create!(option: fly)
end

# Outputs
puts 'Adding Outputs'
Output.destroy_all
outputs = %w[Influent Effluent]
outputs.each do |output|
  Output.create!(name: output)
end

# Tasks
puts 'Adding Tasks'
# enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
# enum input_type: ['checkbox', 'inches', 'pH record', 'date', 'PSI', 'boolean', '% of bed', 'Low/Medium/High Density', 'COD Record', 'Low/Medium/Strong Odor', 'file']
Task.destroy_all
tasks = [{ name: 'Check pH onsite equipement', comment: 'If pH is < 5.5 or > 8.5 call Supervisor', input_type: 2, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check chemical level', comment: 'Ask more if needed', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check in/out of EQ tank for leaks or blocks', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check pump for leaks and noise', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Clean mesh bag', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Pump maintenance', comment: 'Open, clean and replace seals', input_type: 3, frecuency: 4, cycle: '{"months":[{"month":3},{"month":9}],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check both pumps for leaks and noise', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Revise irrigation', comment: 'Ensure adequate pressure and dispersal - notify BF Supervisor if any problem', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check BIDA unit for leaks', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Larvae control product BTi', comment: '1 ounces in EQ tank', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Add bacteria to EQ tank', comment: '0.25 pounds', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"wed","week":1,"num":3}]}', responsible: 1 },
         { name: 'Till puddles', comment: '', input_type: 5, frecuency: 1, cycle: '{"months":[],"days":[{"day":"wed","week":1,"num":3}]}', responsible: 1 },
         { name: 'Unclog sprinklers head', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"wed","week":1,"num":3}]}', responsible: 1 },
         { name: 'Check worms density', comment: '1 sample every 5,000 sqf', input_type: 7, frecuency: 3, cycle: '{"months":[],"days":[{"day":"mon","week":2,"num":8}]}', responsible: 1 },
         { name: 'Validate pH sensor record onsite with paper/equipement', comment: 'Calibrate sensor in water if there is difference on records', input_type: 2, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Calibrate Sensors', comment: '', input_type: 0, frecuency: 3, cycle: '{"months":[],"days":[{"day":"wed","week":1,"num":3}]}', responsible: 1 },
         { name: 'Replace Sensor', comment: '', input_type: 0, frecuency: 4, cycle: '{"months":[{"month":6}],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Water lab sample BOD/TSS', comment: '1st week of the month', input_type: 3, frecuency: 3, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Smell treated water', comment: '', input_type: 9, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Check pit filter', comment: '1 wash cycle', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Replace pits in pit filter', comment: '1 wash cycle', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1, season: 1 },
         { name: 'Clean screen basket', comment: 'Influent and effluent', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Remove bins with pits', comment: 'Influent and effluent', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 0 },
         { name: 'Check pH chemical tank level', comment: '', input_type: 0, frecuency: 0, cycle: '', responsible: 0 },
         { name: 'Regulate dosing point on chemical dosing pump to achieve pH range', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"tue","week":1,"num":2}]}', responsible: 0 },
         { name: 'Clean influent screen', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Revise irrigation', comment: 'Ensure adequate pressure and dispersal - notify BF Supervisor if any problem', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 0 },
         { name: 'Check main irrigation pipe pressure', comment: 'Range 14-20', input_type: 4, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","num":1}]}', responsible: 1 },
         { name: 'Larvae control product BTi', comment: '2 ounces/day in EQ tank', input_type: 0, frecuency: 0, cycle: '', responsible: 1, season: 1 },
         { name: 'Spray Permethrin 36.8% concentration in flies & mosquitoes areas', comment: '', input_type: 5, frecuency: 1, cycle: '', responsible: 1, season: 1 },
         { name: 'Add bacteria to EQ tank', comment: '0.5 pounds', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Till puddles', comment: '', input_type: 5, frecuency: 0, cycle: '', responsible: 1 },
         { name: 'Till the complete bed', comment: 'Out of season - Sunday in preference', input_type: 6, frecuency: 3, cycle: '{"months":[],"days":[{"day":"sun","week":1,"num":7}]}', responsible: 1, season: 2 },
         { name: 'Till the complete bed', comment: 'In season - Sunday in preference', input_type: 6, frecuency: 2, cycle: '{"months":[],"days":[{"day":"sun","week":1,"num":7}]}', responsible: 1, season: 1 },
         { name: 'Check worms density', comment: '1 sample every 5,000 sqf', input_type: 7, frecuency: 3, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 },
         { name: 'Clean effluent sieve box', comment: '', input_type: 0, frecuency: 1, cycle: '{"months":[],"days":[{"day":"tue","week":1,"num":2}]}', responsible: 1 },
         { name: 'Telemetry Records', comment: '', input_type: 2, frecuency: 1, cycle: '{"months":[],"days":[{"day":"wed","week":1,"num":3}]}', responsible: 1 },
         { name: 'Water internal sample COD', comment: '', input_type: 8, frecuency: 3, cycle: '{"months":[],"days":[{"day":"mon","week":1,"num":1}]}', responsible: 1 }]
tasks.each do |task|
  Task.create!(name: task[:name],
               cycle: task[:cycle],
               season: task[:season] || 0,
               comment: task[:comment],
               frecuency: task[:frecuency],
               input_type: task[:input_type],
               responsible: task[:responsible])
end

# Charts
puts 'Adding Charts'
Chart.destroy_all
charts = [
  { name: 'Monthly Flow', shape: 'column' },
  { name: 'Daily Flow', shape: 'bar' },
  { name: 'Monthly Water Analysis Samples', shape: 'datatable' },
  { name: 'Treated Water History', shape: 'datatable' },
  { name: '12 Month Water Analysis Data', shape: 'datatable' },
  { name: 'Lifetime Water Analysis Overview', shape: 'datatable' }
]
charts.each do |chart|
  Chart.create!(name: chart[:name], shape: chart[:shape])
end


# # Add Plants Flows
# puts 'Adding First Plant Flows'
# flow_history = {
#   "_2016": {
#     "_09": [nil, 612, 759, nil, 471, 675, 1132, 977, 925, 1008, 860, 960, 250, nil, 269, 278, nil, nil, 559, 1045, 738, 669, 826, 151, nil, 606, 1016, 942, 680, 1043],
#     "_10": [996, 667, 590, 837, 1053, 1040, 1022, 734, 612, 1040, 795, 978, 1005, 118, 1021, 993, 406, 581, 680, 0, 473, 757, 984, 849, 677, 517, 967, 795, 393, 619, 551],
#     "_11": [1144, 401, 0, 213, 483, 1, 167, 125, 382, 498, 668, 249, 0, 1, 188, 2, 153, 105, 706, 3, 358, 437, 885, 314, 3, 149, 23, 206, 332, 278],
#     "_12": [577, 308, 2, 1, 208, 1, 1, 306, 1, 628, 1, 400, 315, 4, 1117, 228, 1, 4, 2, 449, 2, 11, 239, 1, 1, 2, 1, 68, 1, 1, 1]
#   },
#   "_2017": {
#     "_01": [2, 1, 578, 1344, 933, 188, 879, 1178, 901, 1089, 1047, 1051, 1136, 263, 1, 649, 1216, 1112, 1271, 1267, 536, 1087, 266, 206, 1, 0, 609, 0, 0, 718, 686],
#     "_02": [745, 1021, 1174, 516, 258, 1139, 966, 1034, 1060, 1057, 145, 1, 79, 281, 223, 203, 220, 209, 71, 459, 789, 360, 700, 87, 315, 2, 78, 213],
#     "_03": [1, 240, 446, 645, 2, 835, 1006, 0, 241, 168, 533, 1, 639, 1753, 1034, 778, 155, 558, 1, 144, 698, 252, 488, 438, 1, 82, 244, 424, 1, 581, 228],
#     "_04": [1, 0, 115, 269, 503, 987, 1652, 1008, 2, 0, 73, 928, 679, 482, 1, 68, 518, 1323, 641, 638, 875, 0, 62, 235, 421, 381, 347, 1, 1, 0],
#     "_05": [0, 55, 0, 2, 1, 1, 1, 0, 0, 652, 0, 1, 1, 0, 2, 299, 119, 714, 1, 0, 0, 1751, 78, 143, 1, 1, 1, 0, 0, 1131, 1655],
#     "_06": [1608, 1710, 1858, 2083, 1769, 1880, 1160, 45, 2, 1, 1, 1534, 1675, 1196, 601, 576, 0, 1, 1191, 618, 227, 137, 1150, 0, 0, 823, 829, 1517, 840, 1],
#     "_07": [0, 0, 0, 0, 1, 1139, 580, 1, 0, 791, 871, 657, 1205, 763, 0, 0, 2937, 506, 719, 1455, 727, 0, 0, 364, 696, 550, 877, 1, 0, 0, 923],
#     "_08": [1391, 1, 115, 1, 0, 0, 1, 245, 129, 1, 893, 0, 0, 1354, 1844, 1130, 824, 240, 1, 1, 793, 879, 485, 1, 445, 0, 0, 156, 0, 1441, 607],
#     "_09": [842, 1, 0, 1, 1848, 380, 673, 1387, 659, 111, 93, 2445, 1144, 416, 303, 1050, 286, 470, 456, 1548, 1145, 1894, 156, 490, 1443, 1414, 1934, 986, 1142, 664],
#     "_10": [1207, 1597, 1837, 1405, 1434, 1090, 1009, 1557, 723, 1402, 2158, 1364, 1623, 1201, 1941, 1448, 582, 2, 0, 1, 0, 0, 0, 1780, 2832, 1613, 1496, 1318, 1750, 1370, 327],
#     "_11": [1101, 856, 1134, 1513, 1308, 1003, 1302, 894, 1327, 1067, 0, 142, 909, 1535, 1291, 5684, 293, 7, 0, 158, 161, 464, 0, 0, 0, 0, 4113, 1394, 1828, 683],
#     "_12": [364, 260, 0, 0, 0, 0, 0, 129, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 422, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
#   },
#   "_2018": {
#     "_01": [0, 139, 230, 6, 397, 0, 1, 1732, 1032, 300, 349, 739, 0, 0, 894, 881, 800, 734, 157, 139, 0, 134, 681, 729, 1065, 0, 0, 0, 0, 482, 730],
#     "_02": [352, 150, 1, 0, 246, 768, 801, 699, 460, 0, 0, 1311, 840, 680, 316, 638, 0, 0, 0, 837, 287, 413, 0, 0, 0, 1057, 1238, 680],
#     "_03": [1032, 1137, 0, 122, 325, 1276, 172, 1080, 536, 0, 0, 250, 479, 304, 360, 811, 0, 0, 1721, 1412, 740, 1212, 417, 0, 0, 1978, 348, 0, 0, 114, 0],
#     "_04": [0, 239, 168, 189, 147, 433, 302, 0, 434, 0, 0, 187, 0, 0, 0, 637, 466, 0, 435, 0, 1, 0, 0, 1, 0, 130, 167, 0, 0, 147],
#     "_05": [1, 0, 124, 1, 0, 0, 0, 119, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 178, 0, 0, 0, 0, 173, 527, 173],
#     "_06": [0, 0, 0, 1, 0, 114, 136, 137, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 124, 0, 0],
#     "_07": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 0, 0, 0, 0, 189, 0, 0, 0, 0, 0, 0, 382, 354, 534, 0, 0, 461, 411],
#     "_08": [598, 575, 0, 0, 0, 655, 170, 910, 915, 519, 0, 0, 1269, 314, 0, 0, 0, 0, 0, 246, 0, 143, 0, 0, 0, 0, 0, 0, 0, 0, 0],
#     "_09": [0, 0, 0, 0, 0, 318, 409, 0, 0, 368, 307, 223, 0, 120, 0, 0, 1079, 1067, 737, 722, 419, 1159, 847, 880, 2148, 813, 799, 1184, 1625, 1276],
#     "_10": [453, 1977, 1694, 620, 1144, 1923, 1151, 1318, 1141, 1212, 690, 945, 995, 620, 1963, 1168, 1897, 1099, 1056, 1658, 1217, 556, 1090, 1319, 1129, 641, 943, 1508, 969, 85, 4],
#     "_11": [4, 5, 5, 7, 9, 11, 9, 8, 1261, 1820, 734, 968, 339, 1132, 968, 1, 149, 1139, 452, 418, 1198, 171, 211, 987, 183, 785, 455, 615, 1591, 1551],
#     "_12": [132, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 5, 0, 129, 128, 3, 0, 1467, 530, 0, 0, 0, 121, 7, 1, 0, 0, 0, 0, 1]
#   },
#   "_2019": {
#     "_01": [1, 129, 0, 0, 0, 961, 264, 548, 252, 165, 123, 0, 0, 0, 256, 1187, 1586, 316, 0, 132, 681, 811, 494, 599, 162, 0, 0, 634, 738, 718, 650],
#     "_02": [915, 765, 433, 1114, 651, 663, 713, 734, 138, 1, 811, 950, 2101, 3795, 3533, 4120, 4775, 5278, 3696, 998, 48, 38, 22, 243, 942, 3, 856, 1],
#     "_03": [277, 1086, 0, 395, 253, 1332, 354, 0, 128, 0, 600, 261, 450, 491, 1, 0, 0, 132, 0, 198, 0, 278, 297, 0, 1, 0, 355, 716, 1, 1, 1],
#     "_04": [0, 0, 125, 0, 0, 0, 0, 297, 1, 1, 1, 0, 1, 0, 221, 112, 0, 1, 107, 1, 0, 2, 0, 1, 154, 0, 1, 0, 0, 0],
#     "_05": [0, 0, 0, 0, 0, 124, 0, 33, 0, 1, 0, 0, 0, 0, 293, 702, 687, 185, 462, 1, 278, 129, 197, 0, 0, 0, 0, 367, 557, 69, 263],
#     "_06": [0, 1, 1, 5, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 111, 0, 159, 1, 0, 0, 0, 0, 0, 45, 0, 1, 0],
#     "_07": [0, 145, 129, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 464, 0, 0, 216, 465, 409, 633, 602, 102, 0, 475, 541, 239]
#   }
# }
#
# plant = Plant.find_by(name: 'St Helena')
# flow_history.each do |data_key, data_value|
#   year = data_key.to_s.delete!('_').to_i
#   data_value.each do |hash_key, hash_value|
#     month = hash_key.to_s.delete!('_').to_i
#     fr = FlowReport.create!(plant: plant, date: Date.new(year, month, 1))
#     hash_value.each_with_index do |value_key, i|
#       fr.flows.create!(plant: plant, value: value_key, date: Date.new(year, month, (i + 1)))
#     end
#   end
# end
# puts 'End First Plant Flows'
#
#
# # Add Plants Samplings
# puts 'Adding First Plant Samplings'
#
# st_helena_samplings = [
#   { BOD: { in: 780, out: 220, date: '2016-09-22' }, TSS: { in: 69, out: 50, date: '2016-09-22' } },
#   { BOD: { in: 2500, out: 15, date: '2016-10-05' }, TSS: { in: 200, out: 14, date: '2016-10-05' } },
#   { BOD: { in: 1100, out: 13, date: '2016-11-25' }, TSS: { in: 140, out: 11, date: '2016-11-25' } },
#   { BOD: { in: 840, out: 3, date: '2016-12-14' }, TSS: { in: 160, out: 6, date: '2016-12-14' } },
#   { BOD: { in: 95, out: 2, date: '2017-01-03' }, TSS: { in: 96, out: 0, date: '2017-01-03' } },
#   { BOD: { in: 4200, out: 2, date: '2017-02-01' }, TSS: { in: 180, out: 0, date: '2017-02-01' } },
#   { BOD: { in: 910, out: 2, date: '2017-03-01' }, TSS: { in: 320, out: 0, date: '2017-03-01' } },
#   { BOD: { in: 1200, out: 2, date: '2017-04-06' }, TSS: { in: 360, out: 0, date: '2017-04-06' } },
#   { BOD: { in: 400, out: 1, date: '2017-05-02' }, TSS: { in: 440, out: 0, date: '2017-05-02' } },
#   { BOD: { in: 910, out: 5, date: '2017-06-07' }, TSS: { in: 510, out: 7, date: '2017-06-07' } },
#   { BOD: { in: 830, out: 3, date: '2017-07-06' }, TSS: { in: 200, out: 6, date: '2017-07-06' } },
#   { BOD: { in: 1100, out: 2, date: '2017-08-03' }, TSS: { in: 74, out: 0, date: '2017-08-03' } },
#   { BOD: { in: 750, out: 4, date: '2017-09-08' }, TSS: { in: 40, out: 6, date: '2017-09-08' } },
#   { BOD: { in: 1900, out: 6, date: '2017-10-06' }, TSS: { in: 510, out: 6, date: '2017-10-06' } },
#   { BOD: { in: 4300, out: 180, date: '2017-11-30' }, TSS: { in: 950, out: 24, date: '2017-11-30' } },
#   { BOD: { in: 1200, out: 18, date: '2017-12-15' }, TSS: { in: 170, out: 5, date: '2017-12-15' } },
#   { BOD: { in: 3000, out: 280, date: '2018-01-17' }, TSS: { in: 970, out: 9, date: '2018-01-17' } },
#   { BOD: { in: 1100, out: 23, date: '2018-02-15' }, TSS: { in: 910, out: 12, date: '2018-02-15' } },
#   { BOD: { in: 5800, out: 230, date: '2018-03-02' }, TSS: { in: 2000, out: 16, date: '2018-03-02' } },
#   { BOD: { in: 340, out: 39, date: '2018-04-06' }, TSS: { in: 250, out: 350, date: '2018-04-06' } },
#   { BOD: { in: 1300, out: 6, date: '2018-05-02' }, TSS: { in: 2800, out: 21, date: '2018-05-02' } },
#   { BOD: { in: 1300, out: 38, date: '2018-06-07' }, TSS: { in: 920, out: 38, date: '2018-06-07' } },
#   { BOD: { in: 320, out: 64, date: '2018-07-11' }, TSS: { in: 3400, out: 21, date: '2018-07-11' } },
#   { BOD: { in: 3300, out: 0, date: '2018-08-23' }, TSS: { in: 420, out: 0, date: '2018-08-23' } },
#   { BOD: { in: 2600, out: 10, date: '2018-09-20' }, TSS: { in: 1000, out: 12, date: '2018-09-20' } },
#   { BOD: { in: 1800, out: 6, date: '2018-10-11' }, TSS: { in: 1800, out: 8, date: '2018-10-11' } },
#   { BOD: { in: 7700, out: 2, date: '2018-11-13' }, TSS: { in: 37000, out: 0, date: '2018-11-13' } },
#   { BOD: { in: 2800, out: 13, date: '2018-12-07' }, TSS: { in: 2700, out: 9, date: '2018-12-07' } },
#   { BOD: { in: 1900, out: 5, date: '2019-01-10' }, TSS: { in: 8100, out: 6, date: '2019-01-10' } },
#   { BOD: { in: 1400, out: 5, date: '2019-02-11' }, TSS: { in: 5200, out: 12, date: '2019-02-11' } },
#   { BOD: { in: 810, out: 12, date: '2019-03-05' }, TSS: { in: 1700, out: 27, date: '2019-03-05' } },
#   { BOD: { in: 670, out: 6, date: '2019-04-08' }, TSS: { in: 1200, out: 17, date: '2019-04-08' } },
#   { BOD: { in: 2100, out: 7, date: '2019-05-09' }, TSS: { in: 1100, out: 10, date: '2019-05-09' } },
#   { BOD: { in: 330, out: 6, date: '2019-06-04' }, TSS: { in: 5900, out: 9, date: '2019-06-04' } },
#   { BOD: { in: 550, out: 3, date: '2019-07-10' }, TSS: { in: 470, out: 9, date: '2019-07-10' } }
# ]
#
# Sampling.destroy_all
# SamplingList.destroy_all
# # plant = Plant.find_by(name: 'St Helena')
# lab_access = Access.find_by(name: 'Lab')
# monthly_frecuency = Frecuency.find_by(name: 'Monthly')
#
# st_helena_samplings.each do |samplings|
#   d = samplings[samplings.keys.first][:date].split('-').map(&:to_i)
#   year = d.first
#   month = d.second
#   day = d.third
#   date = Date.new(year, month, day)
#
#   sampling_list = SamplingList.create!(plant: plant, access: lab_access, frecuency: monthly_frecuency, per_cycle: 1, date: Date.new(year, month, 1), created_at: "#{year}-#{month}-1 08:00:00", updated_at: "#{year}-#{month}-1 08:00:00")
#
#   samplings.keys.each do |key|
#     standard = plant.standards.select { |s| s.option.name == key.to_s }.first
#     sampling_list.samplings.create!(standard: standard, date: date, value_in: samplings[key][:in], value_out: samplings[key][:out], created_at: "#{year}-#{month}-#{day} 08:00:00", updated_at: "#{year}-#{month}-#{day} 08:00:00")
#   end
# end
# puts 'End First Plant Samplings'

puts '----------- Seeds Added! -----------'
