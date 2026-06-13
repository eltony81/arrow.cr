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
  alias GArrowDataType = Void*
  alias GArrowTensor = Void*

  # DataType constructors
  fun garrow_int8_data_type_new : GArrowDataType
  fun garrow_uint8_data_type_new : GArrowDataType
  fun garrow_int16_data_type_new : GArrowDataType
  fun garrow_uint16_data_type_new : GArrowDataType
  fun garrow_int32_data_type_new : GArrowDataType
  fun garrow_uint32_data_type_new : GArrowDataType
  fun garrow_int64_data_type_new : GArrowDataType
  fun garrow_uint64_data_type_new : GArrowDataType
  fun garrow_float_data_type_new : GArrowDataType
  fun garrow_double_data_type_new : GArrowDataType
  fun garrow_boolean_data_type_new : GArrowDataType

  # Tensor creation
  fun garrow_tensor_new(data_type : GArrowDataType, data : GArrowBuffer, shape : Int64*, n_dimensions : LibC::SizeT, strides : Int64*, n_strides : LibC::SizeT, dimension_names : UInt8**, n_dimension_names : LibC::SizeT) : GArrowTensor

  # Tensor properties
  fun garrow_tensor_get_value_data_type(tensor : GArrowTensor) : GArrowDataType
  fun garrow_tensor_get_buffer(tensor : GArrowTensor) : GArrowBuffer
  fun garrow_tensor_get_shape(tensor : GArrowTensor, n_dimensions : Int32*) : Int64*
  fun garrow_tensor_get_strides(tensor : GArrowTensor, n_strides : Int32*) : Int64*
  fun garrow_tensor_get_n_dimensions(tensor : GArrowTensor) : Int32
  fun garrow_tensor_get_size(tensor : GArrowTensor) : Int64

  # GArrowBuffer data access
  fun garrow_buffer_get_data(buffer : GArrowBuffer) : Void*
  fun g_bytes_get_data(bytes : Void*, size : LibC::SizeT*) : Void*
  fun g_bytes_unref(bytes : Void*) : Void

  alias GArrowField = Void*
  alias GArrowSchema = Void*
  alias GArrowTable = Void*
  alias GError = Void*

  # GLib list helpers
  fun g_list_append(list : Void*, data : Void*) : Void*
  fun g_list_free(list : Void*) : Void

  # C Data Interface
  fun garrow_array_import(c_abi_array : Void*, data_type : GArrowDataType, error : GError*) : GArrowArray
  fun garrow_array_export(array : GArrowArray, c_abi_array : Void**, c_abi_schema : Void**, error : GError*) : Bool

  # Field, Schema, Table
  fun garrow_field_new(name : UInt8*, data_type : GArrowDataType) : GArrowField
  fun garrow_schema_new(fields : Void*) : GArrowSchema
  fun garrow_table_new_arrays(schema : GArrowSchema, arrays : GArrowArray*, n_arrays : LibC::SizeT, error : GError*) : GArrowTable

  # Compute functions
  fun garrow_compute_initialize(error : GError*) : Bool
end
