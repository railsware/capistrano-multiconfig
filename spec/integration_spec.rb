describe "integration" do
  def run_cap(args)
    Dir.chdir 'fixtures' do
      `env CONFIG_ROOT=#{config_root} bundle exec cap #{args}`
    end
  end

  describe "displaying tasks" do
    subject do
      run_cap("-T")
    end

    context "two files root" do
      let(:config_root) { "config/two_files" }

      it "should display configurations" do
        subject.should == <<-TEXT
cap production  # Load production configuration
cap staging     # Load staging configuration
TEXT
      end
    end

    context "third level nested root" do
      let(:config_root) { "config/third_level_nested" }

      it "should display configurations" do
        subject.should == <<-TEXT
cap app:blog:production  # Load app:blog:production configuration
cap app:blog:staging     # Load app:blog:staging configuration
cap app:wiki:production  # Load app:wiki:production configuration
cap app:wiki:qa          # Load app:wiki:qa configuration
TEXT
      end
    end
  end

  describe "task invocation" do

    context "sample configurations" do
      let(:config_root) { 'config/sample' }

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
      let(:config_root) { 'config/nested_with_shared_file' }
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
      let(:config_root) { 'config/double_nested_shared_file' }
      subject { run_cap("level0:level1:config hello_world") }
      it "should display nested message from all levels" do
          subject.should == "hello from level0 level1 world\n"
      end
    end
  end

end
