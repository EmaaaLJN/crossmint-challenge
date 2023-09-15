FactoryBot.define do
  factory :coordenate do
    coordenate_on { nil }
  end
end

# == Schema Information
#
# Table name: coordenates
#
#  id          :bigint           not null, primary key
#  target_type :string(255)      not null
#  x           :integer
#  y           :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :bigint           not null
#
# Indexes
#
#  index_coordenates_on_target  (target_type,target_id)
#
