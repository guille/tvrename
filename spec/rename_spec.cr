require "./spec_helper"
require "file_utils"

describe TVRename do
  Spec.before_each do
    Dir.mkdir_p(TestUtils.rename_dir)
  end

  Spec.after_each do
    FileUtils.rm_rf(TestUtils.rename_dir)
  end

  context "#rename_in_dir" do
    it "1 - formats formats tv.show.name.sXXeXX.encoder.ext" do
      input = "tv.show.name.s02e01.encoder.ext"
      output = "Tv Show Name S02E01.ext"
      TestUtils.test_rename_helper(input, output)
    end

    it "2 - formats tv show name - XXxXX encoder.ext" do
      input = "tv show name - 02x02 encoder.ext"
      output = "Tv Show Name S02E02.ext"
      TestUtils.test_rename_helper(input, output)
    end

    it "3 - formats Tv Show Name SXXEXX blabla.bla.ext" do
      input = "Tv Show Name S02E03 blabla.bla.ext"
      output = "Tv Show Name S02E03.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "4 - formats Tv Show Name - SXXEXX.encoder.ext" do
      input = "Tv Show Name - S02E04.encoder.ext"
      output = "Tv Show Name S02E04.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "5 - formats tv show name SXXEXX.ext" do
      input = "tv show name S02E05.ext"
      output = "Tv Show Name S02E05.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "6 - formats tv.show.name.XXXX.ext" do
      input = "tv.show.name.206.ext"
      output = "Tv Show Name S02E06.ext"

      TestUtils.test_rename_helper(input, output)

      input = "tv.show.name.1206.ext"
      output = "Tv Show Name S12E06.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "7 - formats tv show XxXX encoder.ext" do
      input = "tv show 2x07 - titles 107.ext"
      output = "Tv Show S02E07.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "8 - formats tv show sxxxx encoder.ext" do
      input = "tv show s1208 random stuff.ext"
      output = "Tv Show S12E08.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "formats filenames with numbers after season and episode" do
      input = "tv.show.name.s02e10.test.21.ext"
      output = "Tv Show Name S02E10.ext"

      TestUtils.test_rename_helper(input, output)

      input = "tv.show.name.208.test.12.ext"
      output = "Tv Show Name S02E08.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "formats filenames with numbers before season and episode" do
      input = "tv.show.21.name.s02e09.test.ext"
      output = "Tv Show 21 Name S02E09.ext"

      TestUtils.test_rename_helper(input, output)
    end

    it "detects possible conflicts" do
      input = "tv.show.name.308.test.121.ext"
      output = "111"

      expect_raises(TVRename::PossibleConflictError) { TestUtils.test_rename_helper(input, output) }
    end
  end
end
