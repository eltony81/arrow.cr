# Direct C bindings to Apache Arrow GLib

@[Link("arrow-glib")]
@[Link("gobject-2.0")]
lib LibArrowGlib
  alias GArrowBuffer = Void*
  alias GArrowArray = Void*

  # GLib/GObject functions for memory management
  fun g_object_unref(object : Void*) : Void
  fun g_object_ref(object : Void*) : Void*

  # Buffer creation
  fun garrow_buffer_new(data : UInt8*, size : Int64) : GArrowBuffer

  # Metadata query
  fun garrow_array_get_length(array : GArrowArray) : Int64
  fun garrow_array_is_null(array : GArrowArray, i : Int64) : Bool

  # Getters for raw typed values from GArrowNumericArray
  fun garrow_int8_array_get_values(array : GArrowArray, length : Int64*) : Int8*
  fun garrow_uint8_array_get_values(array : GArrowArray, length : Int64*) : UInt8*
  fun garrow_int16_array_get_values(array : GArrowArray, length : Int64*) : Int16*
  fun garrow_uint16_array_get_values(array : GArrowArray, length : Int64*) : UInt16*
  fun garrow_int32_array_get_values(array : GArrowArray, length : Int64*) : Int32*
  fun garrow_uint32_array_get_values(array : GArrowArray, length : Int64*) : UInt32*
  fun garrow_int64_array_get_values(array : GArrowArray, length : Int64*) : Int64*
  fun garrow_uint64_array_get_values(array : GArrowArray, length : Int64*) : UInt64*
  fun garrow_float_array_get_values(array : GArrowArray, length : Int64*) : Float32*
  fun garrow_double_array_get_values(array : GArrowArray, length : Int64*) : Float64*

  # Typed GArrowArray constructors from buffers
  fun garrow_int8_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_uint8_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_int16_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_uint16_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_int32_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_uint32_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_int64_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_uint64_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_float_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_double_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_boolean_array_new(length : Int64, data : GArrowBuffer, null_bitmap : GArrowBuffer, n_nulls : Int64) : GArrowArray
  fun garrow_null_array_new(length : Int64) : GArrowArray
end
