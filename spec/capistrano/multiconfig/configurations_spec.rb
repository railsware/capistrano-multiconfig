require 'capistrano/multiconfig/configurations'

describe Capistrano::Multiconfig::Configurations do

  describe ".find_names" do
    subject { described_class.find_names(config_root) }

    context "empty root" do
      let(:config_root) { 'fixtures/config/empty' }
      it { should == [] }
    end

    context "root with two files" do
      let(:config_root) { 'fixtures/config/two_files' }
      it {
        should == [
          'production',
          'staging'
        ]
      }
    end

    context "root with nested directory and two files inside" do
      let(:config_root) { 'fixtures/config/nested' }
      it {
        should == [
          'app:production',
          'app:staging'
        ]
      }
    end

    context "root with two nested directories and two files inside" do
      let(:config_root) { 'fixtures/config/two_nested' }
      it {
        should == [
          'api:production',
          'api:staging',
          'app:production',
          'app:staging'
        ]
      }
    end

    context "root with third nested directories" do
      let(:config_root) { 'fixtures/config/third_level_nested' }
      it {
        should == [
          'app:blog:production',
          'app:blog:staging',
          'app:wiki:production',
          'app:wiki:qa'
        ]
      }
    end

    context "root nested with shared file" do
      let(:config_root) { 'fixtures/config/nested_with_shared_file' }
      it {
        should == [
          'app:production',
          'app:staging',
        ]
      }
    end

    context "root nested with another file" do
      let(:config_root) { 'fixtures/config/nested_with_another_file' }
      it {
        should == [
          'app:production',
          'app:staging',
          'deploy'
        ]
      }
    end

    context "root nested with shared and another file" do
      let(:config_root) { 'fixtures/config/nested_with_shared_and_another_file' }
      it {
        should == [
          'app:production',
          'app:staging',
          'deploy'
        ]
      }
    end

    context "root with foreign file" do
      let(:config_root) { 'fixtures/config/with_foreign_file' }
      it {
        should == [
          'production',
          'staging'
        ]
      }
    end

  end
end
