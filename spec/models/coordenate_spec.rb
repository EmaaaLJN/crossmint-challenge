# frozen_string_literal: true

require 'rails_helper'

describe Coordenate, type: :model do
  subject { build_stubbed(:coordenate, :for_polyanet) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  context 'when coordenates are negative' do
    before do
      subject.x = -1
      subject.y = -2
    end

    it 'is not valid with x negative' do
      expect(subject).not_to be_valid
    end

    it 'is not valid with y negative' do
      expect(subject).not_to be_valid
    end
  end

  context 'when coordenate is already occupied' do
    before do
      create(:coordenate, :for_cometh, x: 2, y: 3)
    end

    it 'is not valid other object with same coordenates' do
      subject.x = 2
      subject.y = 3

      expect(subject).not_to be_valid
    end
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
