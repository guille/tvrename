require "../tvrename"

directories = ["."]

if !STDIN.tty? && !STDIN.closed?
  text = STDIN.gets_to_end
  directories = text.split("\n") unless !text
  directories.delete("")
elsif ARGV.size > 0
  directories = ARGV
end

begin
  directories.each { |i| TVRename.rename_in_dir(i) }
rescue e : TVRename::PossibleConflictError
  puts "Found possible conflict renaming #{e.message}. The file hasn't been modified"
end
