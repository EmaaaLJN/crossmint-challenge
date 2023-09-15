# frozen_string_literal: true

class Soloon < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy
end

# == Schema Information
#
# Table name: soloons
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
