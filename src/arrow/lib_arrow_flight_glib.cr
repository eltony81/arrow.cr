# Direct C bindings to Apache Arrow Flight GLib

@[Link("arrow-flight-glib")]
lib LibArrowFlightGlib
  alias GArrowFlightClient = Void*

  # A mock/stub init signature for GArrowFlightClient
  fun garrow_flight_client_new(
    location : Void*,
    options : Void*,
    error : LibArrowGlib::GError*
  ) : GArrowFlightClient
end
