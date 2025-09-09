module TVRename
  extend self

  ##
  # Formats the filenames of tv shows and subtitles
  def rename_in_dir(dir)
    look_in = File.join(File.realpath(dir), "*")

    Dir[look_in].each do |entry|
      # Only shallow renaming
      next if File.directory?(entry)
      found = rename_file(File.basename(entry))

      next if !found

      found += File.extname(entry)

      base = File.dirname(entry)
      File.rename(entry, File.join(base, found))
    end
  rescue e : File::NotFoundError
    STDERR.puts "Directory not found: #{e.message}"
  end

  # Return tuple (name, season, episode) instead?
  # https://crystal-lang.org/docs/syntax_and_semantics/literals/named_tuple.html
  private def rename_file(entry)
    patterns = Regex.union(
      /.+\.?[sS]?\d+[eE]\d+/, # showname.s01e02, showname.01e02, showname S1E2
      /.+\.?[sS]\d+[eE]?\d+/, # showname.s01E02, showname.s0102, showname S1E2
      /.+\-? \d+x\d+/,        # showname - 01x02
      /.+\d{3,}+/             # showname.102
    )

    # Removes everything after the match
    found = entry.match(patterns)

    return nil if !found

    found = found[0].gsub(/[\.\-]/, ' ') # Replace periods and dashes with spaces
      .gsub(/\(.+\)/, "")                # Remove everything between parens
      .gsub(/ +/, ' ')                   # Reduce spaces to single spaces
      .gsub(/s(\d)/, "S\\1")             # Upcase the season marker
      .gsub(/ [sS]?(\d+)[exX](\d+)$/, " S\\1e\\2")
    # Insert a season marker if it didn't exist, change x/X for e

    raise PossibleConflictError.new(entry) if found.match(/\d{3,}+.+\d{3,}+/)
    # Possible conflict: showname.308.test.121.ext

    # Upcase tv show name
    found = found.split(" ")
      .map(&.capitalize)
      .join(" ")
      .gsub(/(\d)e(\d)/, "\\1E\\2") # Upcase episode marker

    # Special case: No episode marker (tvshow 206)
    if !found.includes? "E"
      numbers = found.match(/(\d+)$/)
      if !numbers.nil?
        # Assumes most tv shows have 1-99 seasons
        # First half of the number is season, rest is episode number
        divide = numbers[0].size//2
        season = numbers[0][0..divide - 1]
        # Pad season number with a zero if single digit
        season = season.insert(0, "0") if season.size == 1
        episode = numbers[0][divide..-1]
        found = found.gsub(/\d+$/, "S#{season}E#{episode}")
        found = found.gsub(/SS/, "S")
      end
    end

    # Pad season marker with a zero if number following is < 10
    found = found.gsub(/S(\d)E/, "S0\\1E")

    return found
  end

  class PossibleConflictError < Exception
  end
end
