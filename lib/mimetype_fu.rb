class File
  # resulting type for an uploaded file is somewhat tricky
  # it depends mostly of uploaded file size
  # see actioncontroller request.rb file for more details
  def self.mime_type?(file)
    if RUBY_PLATFORM.include? 'mswin32'
      case file
      when File
        EXTENSIONS[File.extname(file.path).delete('.').downcase.to_sym]
      when String
        EXTENSIONS[File.extname(file).delete('.').downcase.to_sym]
      else
        "unknown/unknown" 
      end
    else
      require 'ffi_file_magic'
      fm = FFIFileMagic.new(FFIFileMagic::MAGIC_MIME)
      case file
      when File
        fm.file(file.path)
      when String
        fm.file(file)
      when StringIO
        fm.buffer(file.string)
      when ActionController::UploadedStringIO
        fm.buffer(file.string)
      when ActionController::UploadedTempfile
        file.rewind
        fm.buffer(file.read(10))
      else
        "unknown/unknown" 
      end
    end
  end

  def self.extensions
    EXTENSIONS
  end
end
    
