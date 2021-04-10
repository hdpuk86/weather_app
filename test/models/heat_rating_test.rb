require "test_helper"

class HeatRatingTest < ActiveSupport::TestCase
  def test_can_create
    assert HeatRating.create(min_temp: -100, max_temp: 0, name: 'New')
  end

  def test_name_is_unique
    original = HeatRating.new(min_temp: 5, max_temp: 10, name: 'Unique')
    copy = HeatRating.new(min_temp: 5, max_temp: 10, name: 'Unique')
    assert original.save
    assert_not copy.save
    assert_equal 'Name has already been taken', copy.errors.full_messages.first
  end

  def test_name_is_present
    no_name = HeatRating.new(min_temp: 5, max_temp: 10)
    assert_not no_name.save
    assert_equal 'Name can\'t be blank', no_name.errors.full_messages.first
  end

  def test_min_temp_is_less_than_max_temp
    invalid = HeatRating.new(min_temp: 10, max_temp: 5, name: 'test')
    assert_not invalid.save
    assert_equal "Min temp must be less than #{invalid.max_temp}", invalid.errors.full_messages.first
  end

  def test_temps_must_be_in_valid_range
    too_low = HeatRating.new(min_temp: -101, max_temp: 0, name: 'test')
    assert_not too_low.save
    assert_equal "Min temp must be greater than or equal to #{HeatRating::MINIMUM_VALID_TEMPERATURE}", too_low.errors.full_messages.first

    too_high = HeatRating.new(min_temp: 0, max_temp: 101, name: 'test')
    assert_not too_high.save
    assert_equal "Max temp must be less than or equal to #{HeatRating::MAXIMUM_VALID_TEMPERATURE}", too_high.errors.full_messages.first
  end
end
