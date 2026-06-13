# Apache Arrow Compute wrappers using direct C bindings

class Arrow::Datum
  getter to_unsafe : LibArrowGlib::GArrowDatum

  def initialize(@to_unsafe : LibArrowGlib::GArrowDatum)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def self.new(array : Array)
    new(LibArrowGlib.garrow_array_datum_new(array.to_unsafe))
  end

  def self.new(table : Table)
    new(LibArrowGlib.garrow_table_datum_new(table.to_unsafe))
  end

  def to_array : Array
    value_ptr = Pointer(Void).null
    LibArrowGlib.g_object_get(
      @to_unsafe,
      "value".to_unsafe,
      pointerof(value_ptr),
      Pointer(Void).null
    )
    if value_ptr.null?
      raise "Could not retrieve array from Datum"
    end
    Array.new(value_ptr)
  end
end

class Arrow::Function
  getter to_unsafe : LibArrowGlib::GArrowFunction

  def initialize(@to_unsafe : LibArrowGlib::GArrowFunction)
  end

  def finalize
    LibArrowGlib.g_object_unref(@to_unsafe)
  end

  def self.find(name : String) : Function
    ptr = LibArrowGlib.garrow_function_find(name.to_unsafe)
    if ptr.null?
      raise "Arrow compute function not found: #{name}"
    end
    new(ptr)
  end

  def execute(args : ::Array(Datum)) : Datum
    # Convert args array to GList
    glist = Pointer(Void).null
    args.each do |arg|
      glist = LibArrowGlib.g_list_append(glist, arg.to_unsafe)
    end

    err = Pointer(Void).null.as(LibArrowGlib::GError)
    res = LibArrowGlib.garrow_function_execute(
      @to_unsafe,
      glist,
      Pointer(Void).null, # options
      Pointer(Void).null, # context
      pointerof(err)
    )

    LibArrowGlib.g_list_free(glist)

    if !err.nil?
      raise "Arrow compute execution failed"
    end

    Datum.new(res)
  end

  def self.execute(name : String, args : ::Array(Datum)) : Datum
    find(name).execute(args)
  end
end
