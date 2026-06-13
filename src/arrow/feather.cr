# Apache Arrow Feather writer wrapper using direct C bindings

class Arrow::FeatherWriter
  getter to_unsafe : LibArrowGlib::GArrowFeatherFileWriter

  def initialize(@to_unsafe : LibArrowGlib::GArrowFeatherFileWriter)
  end

  def self.new(path : String)
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibArrowGlib.garrow_feather_file_writer_new_path(path.to_unsafe, pointerof(err))
    if !err.nil?
      raise "Failed to create Feather file writer at: #{path}"
    end
    new(res)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def write(table : Table)
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    LibArrowGlib.garrow_feather_file_writer_write(@to_unsafe, table.to_unsafe, pointerof(err))
    if !err.nil?
      raise "Failed to write table to Feather file"
    end
  end

  def close
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    LibArrowGlib.garrow_feather_file_writer_close(@to_unsafe, pointerof(err))
    if !err.nil?
      raise "Failed to close Feather file writer"
    end
  end
end
