# frozen_string_literal: true

class Cometh < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy

  enum :direction, [:up, :down, :left, :right]
end

# == Schema Information
#
# Table name: comeths
#
#  id         :bigint           not null, primary key
#  direction  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
