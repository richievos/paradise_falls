# encoding: utf-8
require "libusb"

# Platform: 370.2 C
# Material: 216g ABS, Total: 21.01Kg

# 76 06 06 seems to be the extruder temp
# 76 08 08 seems to be the platform temp

# vertical position
# only triggered when maintanence screen is up
# 2014-01-04T22:35:00.177-06:00| vmx| I120: USBIO:  000: 70 32                                           p2
# 0
# 2014-01-04T22:37:30.858-06:00| vmx| I120: USBIO:  000: 00 00 00 00 06                                  .....
# 0.01
# 2014-01-04T23:02:43.729-06:00| vmx| I120: USBIO:  000: fb ff ff ff 06                                  .....
# 0.1
# 2014-01-04T22:35:48.177-06:00| vmx| I120: USBIO:  000: c1 ff ff ff 06                                  .....
# 0.20
# 2014-01-04T22:36:57.858-06:00| vmx| I120: USBIO:  000: 81 ff ff ff 06                                  .....
# 0.20
# 2014-01-04T22:36:57.858-06:00| vmx| I120: USBIO:  000: 81 ff ff ff 06                                  .....
# 1
# 2014-01-04T22:35:27.178-06:00| vmx| I120: USBIO:  000: 7c fd ff ff 06                                  |....

# This seems to be little endian
#   big endian to little endian converter
#   ["c1 ff ff ff".gsub(' ', '')].pack('H*').unpack('N*').pack('V*').unpack('H*')
# This also seems like it needs to be not'd
#   ["c1 ff ff ff".gsub(' ', '')].pack('H*').unpack('N*').pack('V*').unpack('H*').
#     first.hex.to_s(2).gsub("1", "x").gsub("0", "1").gsub("x", "0").to_i(2)

# So if this is right, at least on my printer, each 0.1 is 62


###########
# Vertical move
# 0.01
# 2014-01-05T17:59:25.980-06:00: 4a 02 00 00 20 41 0a d7 23 bc => 06
# 2014-01-05T17:59:26.960-06:00: 70 32 => fb ff ff ff 06
# 0.02
# 2014-01-05T17:59:40.062-06:00: 4a 02 00 00 20 41 0a d7 a3 bc => 06
# 2014-01-05T17:59:40.961-06:00: 70 32 => f5 ff ff ff 06
# 0.03
# 2014-01-05T18:05:50.869-06:00: 4a 02 00 00 20 41 8f c2 f5 bc => 06
# 2014-01-05T18:05:51.095-06:00: 70 32 => ee ff ff ff 06
# 1
# 2014-01-05T18:06:38.666-06:00: 4a 02 00 00 20 41 00 00 80 bf => 06
# 2014-01-05T18:06:39.097-06:00: 70 32 => 7c fd ff ff 06
# 2
# 2014-01-05T18:08:19.659-06:00: 4a 02 00 00 20 41 00 00 00 c0 => 06
# 2014-01-05T18:08:20.158-06:00: 70 32 => f8 fa ff ff 06

# 0.01: 4a 02 00 00 20 41 0a d7 23 bc => 06
# 0.02: 4a 02 00 00 20 41 0a d7 a3 bc => 06
# 0.03: 4a 02 00 00 20 41 8f c2 f5 bc => 06
# 1:    4a 02 00 00 20 41 00 00 80 bf => 06
# 2:    4a 02 00 00 20 41 00 00 00 c0 => 06

# 76 is read
# 4a is move
# 06 seems to be "ok"

# FR
# 2014-01-05T18:16:13.607-06:00: 76 00 00 => 01 00 00 00 06
# FL
# 2014-01-05T18:13:19.868-06:00: 76 00 00 => 01 00 00 00 06
# Center
# 2014-01-05T18:13:43.367-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:13:44.868-06:00: 76 00 00 => 03 00 00 00 06
# NL
# 2014-01-05T18:20:41.193-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:20:43.193-06:00: 76 00 00 => 03 00 00 00 06
# NR

# After FR
# 2014-01-05T18:34:45.973-06:00: 4a 00 00 00 48 42 00 00 20 c1 => 06
# 2014-01-05T18:34:45.976-06:00: 4a 01 00 00 48 42 00 00 02 43 => 06
# 2014-01-05T18:34:46.902-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:34:48.901-06:00: 76 00 00 => 03 00 00 00 06

# After NR
# 2014-01-05T18:35:18.475-06:00: 4a 00 00 00 48 42 00 00 02 c3 => 06
# 2014-01-05T18:35:18.901-06:00: 76 00 00 => 01 00 00 00 06

# After NL
# 2014-01-05T18:36:49.905-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:36:51.906-06:00: 76 00 00 => 03 00 00 00 06

# After FL
# 2014-01-05T18:37:18.905-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:37:20.905-06:00: 76 00 00 => 03 00 00 00 06

# After Center
# 2014-01-05T18:37:48.925-06:00: 4a 00 00 00 48 42 00 00 8c c2 => 06
# 2014-01-05T18:37:48.927-06:00: 4a 01 00 00 48 42 00 00 8c 42 => 06
# 2014-01-05T18:37:48.944-06:00: 76 00 00 => 01 00 00 00 06
# 2014-01-05T18:37:50.906-06:00: 76 00 00 => 03 00 00 00 06

module ParadiseFalls
  class Printer
    include LIBUSB

    # Fetched via system_profiler SPUSBDataType
    #   3DPrinter:
    #     Product ID: 0x0001
    #     Vendor ID: 0x4745
    #     Version:  1.00
    #     Serial Number: <snip>
    #     Speed: Up to 12 Mb/sec
    #     Manufacturer: China Free MC.
    #     Location ID: 0xfa140000 / 6
    #     Current Available (mA): 500
    #     Current Required (mA): Unknown (Device has not been configured)
    UP_PLUS_AND_MINI_USB_IDENTIFICATION = {idVendor: 0x4745, idProduct: 0x0001}

    def self.setup(logger)
      # Arbitrarily grabbing the first device, though technically we could support
      # multiple being attached
      usb = LIBUSB::Context.new
      device = usb.devices(UP_PLUS_AND_MINI_USB_IDENTIFICATION).first

      if device.nil?
        logger.warn "Couldn't find printer. Looking for #{UP_PLUS_AND_MINI_USB_IDENTIFICATION.inspect}"
        false
      else
        new(device, logger)
      end
    end

    def initialize(device, logger)
      @device = device
      @logger = logger

      ### Configuration
      @logger.debug "Found #{@device.bNumConfigurations} configurations"
      config_index = 0
      @logger.debug "Retrieving configuration #{config_index}"
      @device_configuration = @device.config_descriptor(config_index)

      ### Endpoints
      endpoints = @device_configuration.endpoints

      @logger.debug "Found #{endpoints.size} endpoints"
      @logger.debug endpoints.inspect

      # This is 0x01, but looking it up just so I remember how to do it later
      @bulk_output_endpoint = endpoints.detect { |e| e.direction == :out }
      # 0x81, ditto as above
      @bulk_input_endpoint = endpoints.detect { |e| e.direction == :in }
      @logger.debug "bulk_output_endpoint=#{@bulk_output_endpoint}, bulk_input_endpoint=#{@bulk_input_endpoint}"

      ### Interface
      # This is always 0, but again, doing it this was as documentation
      # Also, from the usb scrape:
      #   dev3, ep1 out
      @interface = @device_configuration.interfaces.first
      @logger.debug "Using interface.bInterfaceNumber=#{@interface.bInterfaceNumber}"
    end

    def init_printer
      @logger.info "Initializing printer"

      with_handle do |handle|
        # 2014-01-01T18:56:58.951-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=1 stream=0 datalen=6 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.951-06:00| vmx| I120: USBIO:  000: 56 10 00 00 00 00                               V.....          
        # 2014-01-01T18:56:58.951-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=1 stream=0 datalen=6 numPackets=0 status=0 0

        # 2014-01-01T18:56:58.952-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=81 stream=0 datalen=4096 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.952-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=81 stream=0 datalen=1 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.952-06:00| vmx| I120: USBIO:  000: 06                                              .               

        # 2014-01-01T18:56:58.953-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=1 stream=0 datalen=1 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.953-06:00| vmx| I120: USBIO:  000: 63                                              c               
        # 2014-01-01T18:56:58.954-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=1 stream=0 datalen=1 numPackets=0 status=0 0

        # 2014-01-01T18:56:58.956-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=81 stream=0 datalen=4096 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.956-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=81 stream=0 datalen=1 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.956-06:00| vmx| I120: USBIO:  000: 06                                              .               

        # 2014-01-01T18:56:58.958-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=1 stream=0 datalen=2 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.958-06:00| vmx| I120: USBIO:  000: 4c 30                                           L0              
        # 2014-01-01T18:56:58.959-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=1 stream=0 datalen=2 numPackets=0 status=0 0

        # 2014-01-01T18:56:58.960-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=81 stream=0 datalen=4096 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.960-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=81 stream=0 datalen=5 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.960-06:00| vmx| I120: USBIO:  000: 01 00 00 00 06                                  .....           

        # 2014-01-01T18:56:58.961-06:00| vmx| I120: USBIO: Down dev=3 'usb:3' endpt=1 stream=0 datalen=1 numPackets=0 status=0 0
        # 2014-01-01T18:56:58.961-06:00| vmx| I120: USBIO:  000: 58                                              X               
        # 2014-01-01T18:56:58.961-06:00| vmx| I120: USBIO: Up dev=3 'usb:3' endpt=1 stream=0 datalen=1 numPackets=0 status=0 0


        # Without the below input drains this errors out with:
        #   TRANSFER_TIMED_OUT (LIBUSB::ERROR_TIMEOUT)
        # From the log dump, it looks like the up software is periodically reading data during the
        # initialization, so my guess is the UP is waiting for buffers to clear before receving
        # followup inputs.
        @logger.debug "Initiating initialization sequence"
        perform_send_and_recv(handle, "\x56\x10\x00\x00\x00\x00")
        # These show up in the log, but don't seem to affect initialization
        # perform_send_and_recv("\x06")
        # perform_send_and_recv("\x63")
        perform_send_and_recv(handle, "\x4c\x30")
        perform_send_and_recv(handle, "\x58")
      end
    end

    def check_platform_height
      # 2014-01-04T22:35:00.177-06:00| vmx| I120: USBIO:  000: 70 32                                           p2
      # 0
      # 2014-01-04T22:37:30.858-06:00| vmx| I120: USBIO:  000: 00 00 00 00 06                                  .....
      # 0.01
      # 2014-01-04T23:02:43.729-06:00| vmx| I120: USBIO:  000: fb ff ff ff 06                                  .....
      with_handle do |handle|
        @logger.debug "Sending command"
        height_info = perform_send_and_recv(handle, "\x70\x32")

        height_info, µm_height = height_info[0..4], height_info.bytes.to_a[4].to_f
        # µm_height = 6.2

        @logger.debug "Platform height height_info=#{hex_out(height_info)}, µm_height=#{µm_height}"

        big_endian_to_little_endian = height_info.unpack('N*').pack('V*').unpack('H*').first.hex
        complemented = big_endian_to_little_endian.to_s(2).gsub("1", "x").gsub("0", "1").gsub("x", "0").to_i(2)

        @logger.debug "Platform height: big_endian_to_little_endian=#{big_endian_to_little_endian} complemented=#{complemented}, µm_height=#{µm_height}"

        computed_height_in_um = (complemented / µm_height).round.to_i

        @logger.debug "Platform height calculated: computed_height_in_um=#{computed_height_in_um}"

        computed_height_in_um
      end      
    end

    def check_temperatures
      @logger.info "Retrieving platform and extruder temperatures"
      output = {}
      output[:extruder] = parse_float_string(send_and_recv("\x76\x06\x06"))
      output[:platform] = parse_float_string(send_and_recv("\x76\x08\x08"))
      output
    end

    def send_and_recv(command)
      @logger.info "Sending and receving sequence #{hex_out(command)}"

      with_handle do |handle|
        perform_send_and_recv(handle, command)
      end
    end

    private
    def parse_float_string(str_byte_seq)
      # Input:
      #   80 d5 25 42 06
      # Actual float:
      #   42 25 d5 80
      # 06 appears to just mean "ok"
      byte_seq = str_byte_seq.bytes.to_a
      redone_str_byte_seq = [byte_seq[3], byte_seq[2], byte_seq[1], byte_seq[0]].pack("C*").force_encoding("utf-8")
      redone_str_byte_seq.unpack("g").first
    end

    def perform_send_and_recv(handle, command)
      @logger.debug "Sending command"
      handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: command)
        result = drain_any_input(handle)

      @logger.debug "Received #{hex_out(result)}"
      result
    end

    def hex_out(s)
      s.bytes.map { |b| "%02x" % [b] }.join(" ")
    end

    def with_handle
      @logger.debug "Opening usb interface"
      @device.open_interface(@interface) do |handle|
        @logger.debug "Resetting device"
        handle.reset_device

        @logger.debug "Setting configuration to #{@device_configuration.bConfigurationValue}"
        handle.set_configuration(@device_configuration)

        # @logger.debug "Detaching kernel driver"
        # handle.detach_kernel_driver(@interface)

        yield handle
      end
    end

    def drain_any_input(handle)
      handle.bulk_transfer(endpoint: @bulk_input_endpoint, dataIn: 4_096)
    end
  end
end