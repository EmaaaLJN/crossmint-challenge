# frozen_string_literal: true

class Coordenate < ApplicationRecord
  belongs_to :target, polymorphic: true

  validates :x, :y, presence: true

  validate :coordenate_already_occupied
  validate :coordenate_positive

  def coordenate_positive
    return if x.nil? || y.nil?

    errors.add :x, 'must be positive' if x.negative?
    errors.add :y, 'must be positive' if y.negative?
  end

  def coordenate_already_occupied
    return unless Coordenate.where(x:, y:).count.positive?

    errors.add :x, 'coordenate already occupied'
    errors.add :y, 'coordenate already occupied'
  end
end
