require "spec"
require "../src/tvrename"

module TestUtils
	extend self

	@@rename_dir = File.join(File.dirname(__FILE__), "test")
	def rename_dir
		@@rename_dir
	end

	@@source_dir = File.join(File.dirname(__FILE__), "source")
	def source_dir
		@@source_dir
	end

	@@target_dir = File.join(File.dirname(__FILE__), "target")
	def target_dir
		@@target_dir
	end
	
	def test_rename_helper(initial, expected)
		# Write dummy file
		File.open("#{rename_dir}/#{initial}", "w") { }
		# Run tool
		TVRename.rename_in_dir(rename_dir)
		# Assert files name changed
		File.exists?("#{rename_dir}/#{initial}").should be_false
		File.exists?("#{rename_dir}/#{expected}").should be_true
		# Delete the file afterwards
		File.delete("#{rename_dir}/#{expected}")
	end
end