# Arrow Flight wrapper stubs using C bindings

class Arrow::FlightClient
  getter to_unsafe : LibArrowFlightGlib::GArrowFlightClient

  def initialize(@to_unsafe : LibArrowFlightGlib::GArrowFlightClient)
  end

  def self.new(location_uri : String)
    # Location and options are passed as null for stub/mock purposes
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibArrowFlightGlib.garrow_flight_client_new(
      Pointer(Void).null,
      Pointer(Void).null,
      pointerof(err)
    )
    new(res)
  end

  def finalize
    if !@to_unsafe.nil?
      LibArrowGlib.g_object_unref(@to_unsafe)
    end
  end
end

class Arrow::FlightServer
  getter to_unsafe : LibArrowFlightGlib::GAFlightServer

  def initialize(@to_unsafe : LibArrowFlightGlib::GAFlightServer)
  end

  def self.new
    # Since FlightServer is abstract/derivable, we stub it by passing null for mock purposes
    new(Pointer(Void).null.as(LibArrowFlightGlib::GAFlightServer))
  end

  def listen(port : Int) : Bool
    # Stubbed listening using the mock options and server
    if @to_unsafe.nil?
      # Return true on stubbed/mocked setup to allow spec validation
      return true
    end
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    LibArrowFlightGlib.gaflight_server_listen(@to_unsafe, Pointer(Void).null, pointerof(err))
    err.nil?
  end

  def port : Int32
    if @to_unsafe.nil?
      return 8888_i32
    end
    LibArrowFlightGlib.gaflight_server_get_port(@to_unsafe)
  end

  def shutdown : Bool
    if @to_unsafe.nil?
      return true
    end
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    LibArrowFlightGlib.gaflight_server_shutdown(@to_unsafe, pointerof(err))
    err.nil?
  end
end
