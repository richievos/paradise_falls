require "libusb"

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

    @logger.debug "Opening usb interface"
    @device.open_interface(@interface) do |handle|
      @logger.debug "Resetting device"
      handle.reset_device

      @logger.debug "Setting configuration to #{@device_configuration.bConfigurationValue}"
      handle.set_configuration(@device_configuration)
    end

    @device.open_interface(@interface) do |handle|
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
      handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: "\x56\x10\x00\x00\x00\x00")
        drain_any_input(handle)
      # These show up in the log, but don't seem to affect initialization
      # handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: "\x06")
      #   drain_any_input(handle)
      # handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: "\x63")
      #   drain_any_input(handle)
      handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: "\x4c\x30")
        drain_any_input(handle)
      handle.bulk_transfer(endpoint: @bulk_output_endpoint, dataOut: "\x58")
        drain_any_input(handle)
    end
  end

  private
  def drain_any_input(handle)
    handle.bulk_transfer(endpoint: @bulk_input_endpoint, dataIn: 4_096)
  end
end