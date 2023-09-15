class Cometh < ApplicationRecord
  has_one :coordenate, as: :target
end
