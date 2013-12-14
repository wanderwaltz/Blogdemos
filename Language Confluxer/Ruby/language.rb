# coding: utf-8
require "unicode" # Need unicode gem for UTF-8 downcase 
require "set"     # Set class


module Language

  class Confluxer

    def initialize(*filenames)

      @mapping        = Hash.new
      @starting_pairs = Set.new

      filenames.each do |filename|
        process_file(filename)
      end
    end


    def next(length)

     return unless length > 2

     pair    = @starting_pairs.to_a[rand @starting_pairs.length]
     string  = pair.dup
     length -= 2

     while length > 0 do
      letters = @mapping[pair]

      return string if letters == nil

      nextLetter = letters[rand letters.length]
      string    << nextLetter
      i          = string.length-2
      pair       = string.chars[i..i+1].join
      length    -= 1
    end

    string
  end

  private

  def process_file(filename)

   File.open(filename, "r") do |file_handle|
    file_handle.each_line do |line|
     process_line(line)
   end
 end      

end

def process_line(line)
 line.force_encoding Encoding::UTF_8

 stripped = line.strip
 downcase = Unicode::downcase stripped

 downcase.each_confluxer_group(2,1) do |pair, char, index|
  add_to_mapping(pair, char)

  @starting_pairs << pair if index == 0
end 
end

def add_to_mapping(prefix, value)

 return unless value.length > 0

 values = @mapping[prefix]

 if values == nil
  @mapping[prefix] = values = Array.new
end

values.push value
end
end

end


class String

  def each_confluxer_group(*lengths)

    n = lengths.inject(0) {|sum, l| sum += l}

    return if self.length < n

    result = 0.upto(self.length-n).collect {|i| get_confluxer_group(i, *lengths) }

    if block_given?
      result.each_with_index {|group, i| yield *group, i}
    else
      result
    end
  end

  def get_confluxer_group(start, *lengths)

    subgroups = Array.new

    lengths.inject(start) do |index, len|
      range      = index...index+len
      subgroups << self.chars[range].join
      index     += len
    end

    subgroups
  end
end