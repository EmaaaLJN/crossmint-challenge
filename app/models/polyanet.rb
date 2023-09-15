class Polyanet < ApplicationRecord
  has_one :coordenate, as: :target
end
