class Soloon < ApplicationRecord
  has_one :coordenate, as: :target
end
