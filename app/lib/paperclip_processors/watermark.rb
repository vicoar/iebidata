module Paperclip
  class Watermark < Processor
    # Handles watermarking of images that are uploaded.
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :convert_options, :watermark_path, :overlay, :position
 
    def initialize file, options = {}, attachment = nil
      super
      @file             = file
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @watermark_path   = options[:watermark_path]
      @position         = options[:position].nil? ? "SouthEast" : options[:position]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end
 
    # Performs the conversion of the +file+ into a watermark. Returns the Tempfile
    # that contains the new image.
    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
 
      if @watermark_path
        command = "composite"
        params = "-gravity #{@position} #{@watermark_path} #{fromfile} "
        params += tofile(dst)
        begin
          success = Paperclip.run(command, params)
        rescue PaperclipCommandLineError
          success = false
        end
        unless success
          raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
        end
        return dst
      else
        return @file
      end
    end
 
    def fromfile
      File.expand_path(@file.path)
    end
 
    def tofile(destination)
      File.expand_path(destination.path)
    end
  end
end