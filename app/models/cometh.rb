# frozen_string_literal: true

class Cometh < ApplicationRecord
  has_one :coordenate, as: :target, dependent: :destroy
end
