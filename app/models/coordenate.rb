# frozen_string_literal: true

class Coordenate < ApplicationRecord
  belongs_to :target, polymorphic: true

  scope :comeths, -> { includes(:target).where(target_type: :cometh) }
  scope :polyanets, -> { includes(:target).where(target_type: :polyanet) }

  validates :x, :y, presence: true

  validate :coordenate_already_occupied
  validate :coordenate_positive

  private

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

# == Schema Information
#
# Table name: coordenates
#
#  id          :bigint           not null, primary key
#  target_type :string(255)      not null
#  x           :integer
#  y           :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :bigint           not null
#
# Indexes
#
#  index_coordenates_on_target  (target_type,target_id)
#
