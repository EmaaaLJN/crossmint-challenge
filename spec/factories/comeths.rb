# frozen_string_literal: true

FactoryBot.define do
  factory :cometh do
    direction { Cometh.directions.values.sample }
  end
end

# == Schema Information
#
# Table name: comeths
#
#  id         :bigint           not null, primary key
#  direction  :integer          default("up")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
