# Direct C bindings to Apache Arrow CUDA GLib

@[Link("arrow-cuda-glib")]
@[Link("gobject-2.0")]
lib LibArrowCudaGlib
  alias GArrowCUDADeviceManager = Void*
  alias GArrowCUDAContext = Void*
  alias GArrowCUDABuffer = Void*
  alias GArrowCUDAHostBuffer = Void*
  alias GArrowCUDAIPCMemoryHandle = Void*
  alias GArrowCUDABufferInputStream = Void*
  alias GArrowCUDABufferOutputStream = Void*

  alias GError = Void*
  alias GArrowBuffer = Void*
  alias GArrowRecordBatch = Void*

  fun garrow_cuda_device_manager_new(error : GError*) : GArrowCUDADeviceManager
  fun garrow_cuda_device_manager_get_context(manager : GArrowCUDADeviceManager, gpu_number : Int32, error : GError*) : GArrowCUDAContext
  fun garrow_cuda_device_manager_get_n_devices(manager : GArrowCUDADeviceManager) : LibC::SizeT

  fun garrow_cuda_context_get_allocated_size(context : GArrowCUDAContext) : Int64

  fun garrow_cuda_buffer_new(context : GArrowCUDAContext, size : Int64, error : GError*) : GArrowCUDABuffer
  fun garrow_cuda_buffer_copy_to_host(buffer : GArrowCUDABuffer, position : Int64, size : Int64, error : GError*) : Void*
  fun garrow_cuda_buffer_copy_from_host(buffer : GArrowCUDABuffer, data : UInt8*, size : Int64, error : GError*) : Bool
  fun garrow_cuda_buffer_get_context(buffer : GArrowCUDABuffer) : GArrowCUDAContext
end
