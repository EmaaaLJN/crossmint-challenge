# frozen_string_literal: true

class Cometh < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy
end

# == Schema Information
#
# Table name: comeths
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
