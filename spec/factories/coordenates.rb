# frozen_string_literal: true

FactoryBot.define do
  factory :coordenate do
    transient do
      target { nil }
    end

    x { Faker::Number.between(from: 0, to: 10) }
    y { Faker::Number.between(from: 0, to: 10) }

    target_id { target.id }
    target_type { target.class.name }
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
