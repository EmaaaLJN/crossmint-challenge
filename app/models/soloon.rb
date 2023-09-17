# frozen_string_literal: true

class Soloon < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy

  enum :color, [:white, :blue, :red, :purple]
end

# == Schema Information
#
# Table name: soloons
#
#  id         :bigint           not null, primary key
#  color      :integer          default("white")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
