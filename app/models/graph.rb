# == Schema Information
#
# Table name: graphs
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  comment           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  graph_standard_id :bigint
#  report_id         :bigint
#
# Indexes
#
#  index_graphs_on_graph_standard_id  (graph_standard_id)
#  index_graphs_on_report_id          (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (graph_standard_id => graph_standards.id)
#  fk_rails_...  (report_id => reports.id)

class Graph < ApplicationRecord
  belongs_to :report
  belongs_to :graph_standard
end
