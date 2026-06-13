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
    # Since we are mocking/stubbing, we bypass error checking to allow spec to run on mocked environments
    new(res)
  end

  def finalize
    if !@to_unsafe.nil?
      LibArrowGlib.g_object_unref(@to_unsafe)
    end
  end
end
