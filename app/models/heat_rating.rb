class HeatRating < ApplicationRecord
  MINIMUM_VALID_TEMPERATURE = -100.freeze
  MAXIMUM_VALID_TEMPERATURE = 100.freeze

  validates :min_temp, numericality: {
    greater_than_or_equal_to: MINIMUM_VALID_TEMPERATURE,
    less_than_or_equal_to: MAXIMUM_VALID_TEMPERATURE,
    less_than: Proc.new {|record| record.max_temp }
  }
  validates :max_temp, numericality: {
    greater_than_or_equal_to: MINIMUM_VALID_TEMPERATURE,
    less_than_or_equal_to: MAXIMUM_VALID_TEMPERATURE,
    greater_than: Proc.new {|record| record.min_temp }
  }
  validates :name, presence: true, uniqueness: true
end
