require "spec_helper"

describe TestSuiteSplitter::RspecHelper do
  describe "#rspec_options" do
    it "forwards the tag command to rspec" do
      helper = TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 2, tags: ["~@firefox_skip", "asd"])
      rspec_options = helper.__send__(:rspec_options)
      expect(rspec_options).to eq ["--dry-run", "--format", "json", "--tag", "~@firefox_skip", "--tag", "asd", "spec"]
    end

    it "doesnt include the tag argument if nothing is given" do
      helper = TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 2)
      rspec_options = helper.__send__(:rspec_options)
      expect(rspec_options).to eq ["--dry-run", "--format", "json", "spec"]
    end
  end

  it "excludes types" do
    helper = TestSuiteSplitter::RspecHelper.new(exclude_types: ["system"], groups: 4, group_number: 2)

    ignore_models = helper.__send__(:ignore_type?, "models")
    ignore_system = helper.__send__(:ignore_type?, "system")

    expect(ignore_models).to be false
    expect(ignore_system).to be true
  end

  it "selects only given types" do
    helper = TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 2, only_types: ["system"])

    ignore_models = helper.__send__(:ignore_type?, "models")
    ignore_system = helper.__send__(:ignore_type?, "system")

    expect(ignore_models).to be true
    expect(ignore_system).to be false
  end

  describe "#ignore_type?" do
    it "ignores types not given" do
      helper = TestSuiteSplitter::RspecHelper.new(groups: 1, group_number: 1, only_types: ["system"])

      expect(helper.__send__(:ignore_type?, "system")).to be false
      expect(helper.__send__(:ignore_type?, "model")).to be true
    end
  end

  describe "#sorted_files" do
    it "falls back to sort the files by name" do
      helper = TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 2)

      expect(helper).to receive(:files).and_return(
        "specs/file_b_spec.rb" => {
          examples: 1,
          path: "specs/file_b_spec.rb",
          points: 1
        },
        "specs/file_c_spec.rb" => {
          examples: 1,
          path: "specs/file_c_spec.rb",
          points: 1
        },
        "specs/file_a_spec.rb" => {
          examples: 1,
          path: "specs/file_a_spec.rb",
          points: 1
        }
      )

      files = helper.sorted_files.map { |file| file.fetch(:path) }

      expect(files).to eq [
        "specs/file_a_spec.rb",
        "specs/file_b_spec.rb",
        "specs/file_c_spec.rb"
      ]
    end

    it "doesnt duplicate the same specs in multiple groups" do
      require "json"

      helpers = [
        TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 1),
        TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 2),
        TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 3),
        TestSuiteSplitter::RspecHelper.new(groups: 4, group_number: 4)
      ]

      nemoa_rspec_output = JSON.parse(File.read("spec/test_suite_splitter/rspec_helper/nemoa_rspec_output.json"))

      expect(helpers).to all(receive(:dry_result).and_return(nemoa_rspec_output))

      file_groups = helpers.map { |helper| helper.__send__(:group_files) }

      file_groups.each_with_index do |file_group1, index1|
        file_group1.each do |file_name1|
          file_groups.each_with_index do |file_group2, index2|
            next if index1 == index2

            file_group2.each do |file_name2|
              raise "Found fine in both #{index1} and #{index2}: #{file_name1}" if file_name1 == file_name2
            end
          end
        end
      end
    end
  end
end
