# frozen_string_literal: true

class Polyanet < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy
end
