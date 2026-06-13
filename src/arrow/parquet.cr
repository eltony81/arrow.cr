# Parquet and Tabular wrapper classes using C bindings

class Arrow::Field
  getter to_unsafe : LibArrowGlib::GArrowField

  def initialize(@to_unsafe : LibArrowGlib::GArrowField)
  end

  def initialize(name : String, dtype : DataType)
    @to_unsafe = LibArrowGlib.garrow_field_new(name.to_unsafe, dtype.to_unsafe)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end
end

class Arrow::Schema
  getter to_unsafe : LibArrowGlib::GArrowSchema

  def initialize(@to_unsafe : LibArrowGlib::GArrowSchema)
  end

  def initialize(fields : ::Array(Field))
    glist = Pointer(Void).null
    fields.each do |field|
      glist = LibArrowGlib.g_list_append(glist, field.to_unsafe)
    end
    @to_unsafe = LibArrowGlib.garrow_schema_new(glist)
    LibArrowGlib.g_list_free(glist)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end
end

class Arrow::Table
  getter to_unsafe : LibArrowGlib::GArrowTable

  def initialize(@to_unsafe : LibArrowGlib::GArrowTable)
  end

  def initialize(schema : Schema, arrays : ::Array(Array))
    c_arrays = arrays.map(&.to_unsafe)
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    @to_unsafe = LibArrowGlib.garrow_table_new_arrays(
      schema.to_unsafe,
      c_arrays.to_unsafe,
      LibC::SizeT.new(arrays.size),
      pointerof(err)
    )
    if !err.nil?
      raise "Failed to create Arrow::Table"
    end
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end
end

class Arrow::ParquetWriter
  getter to_unsafe : LibParquetGlib::GParquetArrowFileWriter

  def initialize(@to_unsafe : LibParquetGlib::GParquetArrowFileWriter)
  end

  def initialize(schema : Schema, path : String)
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    @to_unsafe = LibParquetGlib.gparquet_arrow_file_writer_new_path(
      schema.to_unsafe,
      path.to_unsafe,
      pointerof(err)
    )
    if !err.nil?
      raise "Failed to initialize Parquet Writer at path: #{path}"
    end
  end

  def write(table : Table, chunk_size : Int64 = 1024_i64) : Bool
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibParquetGlib.gparquet_arrow_file_writer_write_table(@to_unsafe, table.to_unsafe, chunk_size, pointerof(err))
    if !err.nil?
      raise "Failed to write table to Parquet"
    end
    res
  end

  def close : Bool
    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibParquetGlib.gparquet_arrow_file_writer_close(@to_unsafe, pointerof(err))
    if !err.nil?
      raise "Failed to close Parquet Writer"
    end
    res
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end
end
