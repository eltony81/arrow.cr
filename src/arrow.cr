require "./arrow/lib_arrow_glib"
require "./arrow/lib_parquet_glib"
require "./arrow/lib_arrow_flight_glib"
require "./api"

module Arrow
  VERSION = "1.2.0"

  def self.initialize_compute : Bool
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibArrowGlib.garrow_compute_initialize(pointerof(err))
    if !err.nil?
      raise "Failed to initialize Arrow Compute module"
    end
    res
  end
end
