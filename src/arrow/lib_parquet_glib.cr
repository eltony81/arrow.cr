# Direct C bindings to Apache Parquet GLib

@[Link("parquet-glib")]
lib LibParquetGlib
  alias GParquetArrowFileWriter = Void*

  fun gparquet_arrow_file_writer_new_path(
    schema : LibArrowGlib::GArrowSchema,
    path : UInt8*,
    error : LibArrowGlib::GError*
  ) : GParquetArrowFileWriter

  fun gparquet_arrow_file_writer_write_table(
    writer : GParquetArrowFileWriter,
    table : LibArrowGlib::GArrowTable,
    chunk_size : Int64,
    error : LibArrowGlib::GError*
  ) : Bool

  fun gparquet_arrow_file_writer_close(
    writer : GParquetArrowFileWriter,
    error : LibArrowGlib::GError*
  ) : Bool
end
