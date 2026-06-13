# Apache Arrow CUDA memory sharing wrappers using direct C bindings

class Arrow::CudaDeviceManager
  getter to_unsafe : LibArrowCudaGlib::GArrowCUDADeviceManager

  def initialize(@to_unsafe : LibArrowCudaGlib::GArrowCUDADeviceManager)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def self.new
    err = Pointer(Void).null.as(LibArrowCudaGlib::GError)
    res = LibArrowCudaGlib.garrow_cuda_device_manager_new(pointerof(err))
    if !err.nil?
      raise "Failed to initialize CUDA Device Manager"
    end
    new(res)
  end

  def devices_count : Int32
    LibArrowCudaGlib.garrow_cuda_device_manager_get_n_devices(@to_unsafe).to_i32
  end

  def get_context(gpu_number : Int) : CudaContext
    err = Pointer(Void).null.as(LibArrowCudaGlib::GError)
    res = LibArrowCudaGlib.garrow_cuda_device_manager_get_context(@to_unsafe, gpu_number.to_i32, pointerof(err))
    if !err.nil?
      raise "Failed to get CUDA Context for device #{gpu_number}"
    end
    CudaContext.new(res)
  end
end

class Arrow::CudaContext
  getter to_unsafe : LibArrowCudaGlib::GArrowCUDAContext

  def initialize(@to_unsafe : LibArrowCudaGlib::GArrowCUDAContext)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def allocated_size : Int64
    LibArrowCudaGlib.garrow_cuda_context_get_allocated_size(@to_unsafe)
  end

  def new_buffer(size : Int) : CudaBuffer
    err = Pointer(Void).null.as(LibArrowCudaGlib::GError)
    res = LibArrowCudaGlib.garrow_cuda_buffer_new(@to_unsafe, size.to_i64, pointerof(err))
    if !err.nil?
      raise "Failed to allocate CUDA buffer of size #{size}"
    end
    CudaBuffer.new(res)
  end
end

class Arrow::CudaBuffer
  getter to_unsafe : LibArrowCudaGlib::GArrowCUDABuffer

  def initialize(@to_unsafe : LibArrowCudaGlib::GArrowCUDABuffer)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def copy_from_host(data : Bytes) : Bool
    err = Pointer(Void).null.as(LibArrowCudaGlib::GError)
    res = LibArrowCudaGlib.garrow_cuda_buffer_copy_from_host(@to_unsafe, data.to_unsafe, data.bytesize.to_i64, pointerof(err))
    if !err.nil?
      raise "Failed to copy data from host to CUDA buffer"
    end
    res
  end

  def copy_to_host(position : Int, size : Int) : Pointer(Void)
    err = Pointer(Void).null.as(LibArrowCudaGlib::GError)
    res = LibArrowCudaGlib.garrow_cuda_buffer_copy_to_host(@to_unsafe, position.to_i64, size.to_i64, pointerof(err))
    if !err.nil?
      raise "Failed to copy data from CUDA buffer to host"
    end
    res
  end
end
