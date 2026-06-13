# Direct C bindings to Apache Arrow Flight GLib

@[Link("arrow-flight-glib")]
lib LibArrowFlightGlib
  alias GArrowFlightClient = Void*
  alias GAFlightServer = Void*
  alias GAFlightServerOptions = Void*

  # Mock/stub client init signature
  fun garrow_flight_client_new(
    location : Void*,
    options : Void*,
    error : LibArrowGlib::GError*
  ) : GArrowFlightClient

  # Flight Server signatures
  fun gaflight_server_listen(server : GAFlightServer, options : GAFlightServerOptions, error : LibArrowGlib::GError*) : Bool
  fun gaflight_server_get_port(server : GAFlightServer) : Int32
  fun gaflight_server_shutdown(server : GAFlightServer, error : LibArrowGlib::GError*) : Bool
end
