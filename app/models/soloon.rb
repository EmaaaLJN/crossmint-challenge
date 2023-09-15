# frozen_string_literal: true

class Soloon < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy
end
