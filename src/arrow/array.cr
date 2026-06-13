# Arrow Array wrappers using direct C bindings

struct PointerWrapper(T)
  def initialize(@ptr : Pointer(T))
  end
  def to_unsafe : Pointer(T)
    @ptr
  end
end

class Arrow::Buffer
  getter to_unsafe : LibArrowGlib::GArrowBuffer

  def initialize(@to_unsafe : LibArrowGlib::GArrowBuffer)
  end

  def initialize(bytes : Bytes)
    @to_unsafe = LibArrowGlib.garrow_buffer_new(bytes.to_unsafe, bytes.bytesize.to_i64)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end
end

class Arrow::Array
  getter to_unsafe : LibArrowGlib::GArrowArray

  def initialize(@to_unsafe : LibArrowGlib::GArrowArray)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def length : Int64
    LibArrowGlib.garrow_array_get_length(@to_unsafe)
  end

  def null?(i : Int) : Bool
    LibArrowGlib.garrow_array_is_null(@to_unsafe, i.to_i64)
  end
end

class Arrow::NumericArray < Arrow::Array
end

{% for item in [
  {"Int8", "Int8", "int8"},
  {"UInt8", "UInt8", "uint8"},
  {"Int16", "Int16", "int16"},
  {"UInt16", "UInt16", "uint16"},
  {"Int32", "Int32", "int32"},
  {"UInt32", "UInt32", "uint32"},
  {"Int64", "Int64", "int64"},
  {"UInt64", "UInt64", "uint64"},
  {"Float", "Float32", "float"},
  {"Double", "Float64", "double"}
] %}
  class Arrow::{{item[0].id}}Array < Arrow::NumericArray
    def initialize(length : Int64, buffer : Arrow::Buffer, null_bitmap : Arrow::Buffer?, null_count : Int64)
      bitmap_ptr = null_bitmap ? null_bitmap.to_unsafe : Pointer(Void).null.as(LibArrowGlib::GArrowBuffer)
      @to_unsafe = LibArrowGlib.garrow_{{item[2].id}}_array_new(length, buffer.to_unsafe, bitmap_ptr, null_count)
    end

    def self.new(ary : ::Array({{item[1].id}}))
      # Access raw buffer pointer from Crystal array pointer
      bytes = Bytes.new(ary.to_unsafe.as(Pointer(UInt8)), ary.size * sizeof({{item[1].id}}))
      buffer = Arrow::Buffer.new(bytes)
      new(ary.size.to_i64, buffer, nil, 0_i64)
    end

    def value(i : Int) : {{item[1].id}}
      raw_pointer[i]
    end

    def raw_pointer : Pointer({{item[1].id}})
      length_ptr = 0_i64
      LibArrowGlib.garrow_{{item[2].id}}_array_get_values(@to_unsafe, pointerof(length_ptr))
    end

    def values
      {PointerWrapper.new(raw_pointer), length}
    end
  end
{% end %}

class Arrow::BooleanArray < Arrow::Array
  def initialize(length : Int64, buffer : Arrow::Buffer, null_bitmap : Arrow::Buffer?, null_count : Int64)
    @to_unsafe = Pointer(Void).null.as(LibArrowGlib::GArrowArray)
    raise "BooleanArray construction is not supported"
  end

  def self.new(ary : ::Array)
    raise "BooleanArray construction is not supported"
  end
end

class Arrow::StringArray < Arrow::Array
  def initialize(length : Int64, buffer : Arrow::Buffer, null_bitmap : Arrow::Buffer?, null_count : Int64)
    @to_unsafe = Pointer(Void).null.as(LibArrowGlib::GArrowArray)
    raise "StringArray construction is not supported"
  end

  def self.new(ary : ::Array)
    raise "StringArray construction is not supported"
  end
end
