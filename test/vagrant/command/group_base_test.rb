require "test_helper"

class CommandGroupBaseTest < Test::Unit::TestCase
  setup do
    @klass = Vagrant::Command::GroupBase
    @env = mock_environment
  end

  context "setting up a UI" do
    setup do
      @env.ui = nil
    end

    should "setup a shell UI" do
      silence_stream(STDOUT) { @klass.start([], :env => @env) }
      assert @env.ui.is_a?(Vagrant::UI::Shell)
    end

    should "setup a shell UI only once" do
      silence_stream(STDOUT) { @klass.start([], :env => @env) }
      ui = @env.ui
      silence_stream(STDOUT) { @klass.start([], :env => @env) }
      assert @env.ui.equal?(ui)
    end
  end

  context "requiring an environment" do
    should "raise an exception if the environment is not sent in" do
      assert_raises(Vagrant::CLIMissingEnvironment) {
        @klass.start([])
      }
    end

    should "not raise an exception if the environment is properly sent in" do
      silence_stream(STDOUT) do
        assert_nothing_raised {
          @klass.start([], :env => @env)
        }
      end
    end
  end
end
