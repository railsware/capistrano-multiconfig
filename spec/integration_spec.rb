describe "integration" do
  def run_cap(args)
    Dir.chdir 'fixtures' do
      `env STAGES_ROOT=#{stages_root} bundle exec cap #{args}`
    end
  end

  describe "displaying tasks" do
    subject do
      run_cap("-T")
    end

    context "empty root" do
      let(:stages_root) { 'config/empty' }
      it { should == "" }
    end

    context "two files root" do
      let(:stages_root) { 'config/two_files' }

      it "should display configurations" do
        subject.should == <<-TEXT
cap production  # Load production configuration
cap staging     # Load staging configuration
TEXT
      end
    end

    context "two files with same prefix root" do
      let(:stages_root) { 'config/two_files_with_same_prefix' }

      it "should display configurations" do
        subject.should == <<-TEXT
cap qa   # Load qa configuration
cap qa1  # Load qa1 configuration
TEXT
      end
    end

    context "root with nested directory and two files inside" do
      let(:stages_root) { 'config/nested' }
      it {
        should == <<-TEXT
cap app:production  # Load app:production configuration
cap app:staging     # Load app:staging configuration
TEXT
      }
    end

    context "root with two nested directories and two files inside" do
      let(:stages_root) { 'config/two_nested' }
      it {
        should == <<-TEXT
cap api:production  # Load api:production configuration
cap api:staging     # Load api:staging configuration
cap app:production  # Load app:production configuration
cap app:staging     # Load app:staging configuration
TEXT
      }
    end

    context "root nested with shared file" do
      let(:stages_root) { 'config/nested_with_shared_file' }
      it {
        should == <<-TEXT
cap app:production  # Load app:production configuration
cap app:staging     # Load app:staging configuration
TEXT
      }
    end

    context "root nested with another file" do
      let(:stages_root) { 'config/nested_with_another_file' }
      it {
        should == <<-TEXT
cap app:production  # Load app:production configuration
cap app:staging     # Load app:staging configuration
cap deploy          # Load deploy configuration
TEXT
      }
    end

    context "root nested with shared and another file" do
      let(:stages_root) { 'config/nested_with_shared_and_another_file' }
      it {
        should == <<-TEXT
cap app:production  # Load app:production configuration
cap app:staging     # Load app:staging configuration
cap deploy          # Load deploy configuration
TEXT
      }
    end

    context "root with foreign file" do
      let(:stages_root) { 'config/with_foreign_file' }
      it {
        should == <<-TEXT
cap production  # Load production configuration
cap staging     # Load staging configuration
TEXT
      }
    end

    context "third level nested root" do
      let(:stages_root) { "config/third_level_nested" }

      it  {
        should == <<-TEXT
cap app:blog:production  # Load app:blog:production configuration
cap app:blog:staging     # Load app:blog:staging configuration
cap app:wiki:production  # Load app:wiki:production configuration
cap app:wiki:qa          # Load app:wiki:qa configuration
TEXT
      }
    end
  end



  describe "task invocation" do

    context "sample configurations" do
      let(:stages_root) { 'config/sample' }

      context "without configuration" do
        subject { run_cap("hello_world") }
        it "should require configuration" do
          subject.should include("Stage not set")
        end
      end

      context "with apps:world1 configuration" do
        subject { run_cap("apps:world1 hello_world") }

        it "should use value set in configuration" do
          subject.should == "hello from world1\n"
        end
      end

      context "with apps:world2 configuration" do
        subject { run_cap("apps:world2 hello_world") }

        it "should use value set in configuration" do
          subject.should == "hello from world2\n"
        end
      end
    end

    context "configurations with shared file" do
      let(:stages_root) { 'config/nested_with_shared_file' }
      context "with app:production" do
        subject { run_cap("app:production hello_world") }
        it "should display certain message" do
          subject.should == "hello from production world\n"
        end
      end
      context "with app:staging" do
        subject { run_cap("app:staging hello_world") }
        it "should display shared message" do
          subject.should == "hello from shared world\n"
        end
      end
    end

    context "configuration with double nested shared file" do
      let(:stages_root) { 'config/double_nested_shared_file' }
      subject { run_cap("level0:level1:config hello_world") }
      it "should display nested message from all levels" do
          subject.should == "hello from level0 level1 world\n"
      end
    end

    context "configuration with root and nested" do
      let(:stages_root) { 'config/root_with_nested' }
      subject { run_cap("app:config hello_world") }
      it "should display nested message from root" do
        subject.should == "hello from root world\n"
      end
    end
  end

end
