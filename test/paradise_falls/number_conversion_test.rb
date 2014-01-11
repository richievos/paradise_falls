$:<< "lib"
require "paradise_falls/number_conversion"
require "test/unit"

class NumberConversionTest < Test::Unit::TestCase
  include ParadiseFalls::NumberConversion

  # **Far**:

  #     4a 00 00 00 48 42 00 00 20 c1

  # **Near**:

  #     4a 00 00 00 48 42 00 00 02 c3
  #     4a 00 00 00 48 42 00 00 8c c2

  def test_parse_float_string
    assert_equal 0.0, parse_float_string("\x00\x00\x00\x80")
    assert_equal -100.0, parse_float_string("\x00\x00\xc8\xc2").round(2)
    assert_equal -122.44, parse_float_string("\x48\xe1\xf4\xc2").round(2)
  end

  def test_round_trip_float
    assert_equal -123.45, parse_float_string(generate_float_bytes(-123.45).pack("C*")).round(2)
  end
end
