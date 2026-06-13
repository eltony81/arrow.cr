require "./spec_helper"

describe Arrow do
  it "creates and accesses Int32Array" do
    ary = [1, 2, 3, 4, 5]
    arrow_arr = Arrow::Int32Array.new(ary)
    arrow_arr.length.should eq(5)
    arrow_arr.value(0).should eq(1)
    arrow_arr.value(4).should eq(5)

    # test values pointer iterator
    raw, len = arrow_arr.values
    len.should eq(5)
    ptr = raw.to_unsafe
    ptr[0].should eq(1)
    ptr[4].should eq(5)
  end

  it "creates and accesses DoubleArray (Float64)" do
    ary = [1.5, 2.5, 3.5]
    arrow_arr = Arrow::DoubleArray.new(ary)
    arrow_arr.length.should eq(3)
    arrow_arr.value(0).should eq(1.5)
    arrow_arr.value(2).should eq(3.5)

    raw, len = arrow_arr.values
    len.should eq(3)
    ptr = raw.to_unsafe
    ptr[0].should eq(1.5)
    ptr[2].should eq(3.5)
  end

  it "creates and accesses UInt8Array" do
    ary = [10_u8, 20_u8]
    arrow_arr = Arrow::UInt8Array.new(ary)
    arrow_arr.length.should eq(2)
    arrow_arr.value(0).should eq(10)
    arrow_arr.value(1).should eq(20)

    raw, len = arrow_arr.values
    len.should eq(2)
    ptr = raw.to_unsafe
    ptr[0].should eq(10)
    ptr[1].should eq(20)
  end

  it "creates and queries GArrowTensor (multidimensional array)" do
    shape = [2_i64, 3_i64]
    strides = [12_i64, 4_i64] # 3 * 4 bytes, 4 bytes
    ary = [10_i32, 20_i32, 30_i32, 40_i32, 50_i32, 60_i32]
    
    # Create buffer and dataType
    bytes = Bytes.new(ary.to_unsafe.as(Pointer(UInt8)), ary.size * sizeof(Int32))
    buffer = Arrow::Buffer.new(bytes)
    dtype = Arrow::DataType.int32
    
    # Create tensor
    tensor = Arrow::Tensor.new(dtype, buffer, shape, strides)
    
    tensor.ndim.should eq(2)
    tensor.size.should eq(6)
    tensor.shape.should eq(shape)
    tensor.strides.should eq(strides)
    
    # check data type
    tensor.value_data_type.should be_a(Arrow::DataType)
  end
end
