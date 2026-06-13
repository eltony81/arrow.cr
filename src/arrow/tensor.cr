# Arrow DataType and Tensor wrappers using direct C bindings

class Arrow::DataType
  getter to_unsafe : LibArrowGlib::GArrowDataType

  def initialize(@to_unsafe : LibArrowGlib::GArrowDataType)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def self.int8
    new(LibArrowGlib.garrow_int8_data_type_new)
  end

  def self.uint8
    new(LibArrowGlib.garrow_uint8_data_type_new)
  end

  def self.int16
    new(LibArrowGlib.garrow_int16_data_type_new)
  end

  def self.uint16
    new(LibArrowGlib.garrow_uint16_data_type_new)
  end

  def self.int32
    new(LibArrowGlib.garrow_int32_data_type_new)
  end

  def self.uint32
    new(LibArrowGlib.garrow_uint32_data_type_new)
  end

  def self.int64
    new(LibArrowGlib.garrow_int64_data_type_new)
  end

  def self.uint64
    new(LibArrowGlib.garrow_uint64_data_type_new)
  end

  def self.float
    new(LibArrowGlib.garrow_float_data_type_new)
  end

  def self.double
    new(LibArrowGlib.garrow_double_data_type_new)
  end

  def self.boolean
    new(LibArrowGlib.garrow_boolean_data_type_new)
  end
end

class Arrow::Tensor
  getter to_unsafe : LibArrowGlib::GArrowTensor

  def initialize(@to_unsafe : LibArrowGlib::GArrowTensor)
  end

  def initialize(dtype : DataType, buffer : Buffer, shape : ::Array(Int64), strides : ::Array(Int64)? = nil)
    strides_ptr = strides ? strides.to_unsafe : Pointer(Int64).null
    strides_size = strides ? strides.size : 0
    @to_unsafe = LibArrowGlib.garrow_tensor_new(
      dtype.to_unsafe,
      buffer.to_unsafe,
      shape.to_unsafe,
      LibC::SizeT.new(shape.size),
      strides_ptr,
      LibC::SizeT.new(strides_size),
      Pointer(Pointer(UInt8)).null,
      LibC::SizeT.new(0)
    )
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def value_data_type : DataType
    DataType.new(LibArrowGlib.garrow_tensor_get_value_data_type(@to_unsafe))
  end

  def buffer : Buffer
    Buffer.new(LibArrowGlib.garrow_tensor_get_buffer(@to_unsafe))
  end

  def ndim : Int32
    LibArrowGlib.garrow_tensor_get_n_dimensions(@to_unsafe)
  end

  def size : Int64
    LibArrowGlib.garrow_tensor_get_size(@to_unsafe)
  end

  def shape : ::Array(Int64)
    n_dim = 0_i32
    shape_ptr = LibArrowGlib.garrow_tensor_get_shape(@to_unsafe, pointerof(n_dim))
    ::Array(Int64).new(n_dim) { |i| shape_ptr[i] }
  end

  def strides : ::Array(Int64)
    n_strides = 0_i32
    strides_ptr = LibArrowGlib.garrow_tensor_get_strides(@to_unsafe, pointerof(n_strides))
    ::Array(Int64).new(n_strides) { |i| strides_ptr[i] }
  end
end
