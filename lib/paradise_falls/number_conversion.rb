module ParadiseFalls
  module NumberConversion
    def generate_float_string(float)
      # Input:
      #   41.45849609375
      #   42 25 d5 80
      # Up format:
      #   80 d5 25 42 06
      byte_seq = [float].pack("f").bytes.to_a
      up_byte_seq = [byte_seq[0], byte_seq[1], byte_seq[2], byte_seq[3]]
    end

    def parse_short_string(str_byte_seq)
      # Input:
      #   25 42
      # Actual short:
      #   24 25
      #   579

      # "\xab\xcd" => "badc"
      byte_seq = str_byte_seq.unpack("h*").first
      # ["badc"] => [0xb, 0xa, 0xd, 0xc]
      byte_seq = byte_seq.chars.map(&:hex)
      # dc ab
      # [0xb, 0xa, 0xd, 0xc] => [0xd, 0xc, 0xa, 0xb]
      redone_str_byte_seq = [byte_seq[2], byte_seq[3], byte_seq[0], byte_seq[1]]
      redone_str_byte_seq = [byte_seq[3], byte_seq[2], byte_seq[1], byte_seq[0]].pack("C*").force_encoding("utf-8")
      redone_str_byte_seq.unpack("S").first
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
  end
end