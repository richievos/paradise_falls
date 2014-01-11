module ParadiseFalls
  module NumberConversion
    def generate_float_bytes(float)
      # Input:
      #   41.45849609375
      #   42 25 d5 80
      # Up format:
      #   80 d5 25 42 06
      byte_seq = [float].pack("f").bytes.to_a
      up_byte_seq = [byte_seq[0], byte_seq[1], byte_seq[2], byte_seq[3]]
    end

    def parse_float_string(str_byte_seq)
      # Input:
      #   80 d5 25 42 06
      # Actual float:
      #   42 25 d5 80
      #   41.45849609375
      # 06 appears to just mean "ok"
      byte_seq = str_byte_seq.bytes.to_a
      redone_str_byte_seq = [byte_seq[3], byte_seq[2], byte_seq[1], byte_seq[0]].pack("C*").force_encoding("utf-8")
      redone_str_byte_seq.unpack("g").first
    end

    def generate_ushort_bytes(short)
      # Input:
      #   17096
      # Up format:
      #   ab cd
      #   42 c8
      #   dc ab
      #   8c 42
      # assert_equal 17096, parse_ushort_string("\x8c\x42")

      # 9416 => "24c8"
      bytes_as_hex = ("%02x" % short)
      # "24c8" => "8c42"
      bytes_as_hex = [bytes_as_hex[3], bytes_as_hex[2], bytes_as_hex[0], bytes_as_hex[1]]
      # "8c42" => 0x8c42
      up_bytes_as_num = bytes_as_hex.join("").hex
      # 0x8c42 => "\x8c\x42".bytes.to_a
      [up_bytes_as_num].pack("S>*").bytes.to_a
    end

    def parse_ushort_string(str_byte_seq)
      # Input:
      #   8c 42
      # Actual short:
      #   42 c8
      #   17096

      # "\x8c\x42" => "8c42"
      byte_seq = str_byte_seq.unpack("H*").first
      # ["8", "c", "4", "2"] => ["4", "2", "c", "8"]
      redone_str_byte_seq = [byte_seq[2], byte_seq[3], byte_seq[1], byte_seq[0]]
      redone_str_byte_seq.join.hex
    end
  end
end