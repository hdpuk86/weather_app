class UkPostcodeValidator < ActiveModel::Validator
  def validate(record)
    return if is_valid_uk_format?(record)

    record.errors.add(:postcode, 'must be in a valid UK format')
  end

  def is_valid_uk_format?(record)
    uk_postcode_regex = /([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\s?[0-9][A-Za-z]{2})/
    uk_postcode_regex.match?(record.postcode)
  end
end
