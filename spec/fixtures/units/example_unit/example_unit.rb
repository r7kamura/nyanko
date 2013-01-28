module ExampleUnit
  include Nyanko::Unit

  shared(:shared) do |args|
    "shared #{args}"
  end

  scope(:controller) do
    function(:test) do
      "test"
    end

    function(:foo) do
      "foo"
    end

    function(:bar) do
      "bar"
    end

    function(:alias) do
      "alias"
    end

    function(:default) do
      run_default
    end
  end

  scope(:view) do
    function(:test) do
      "test"
    end

    function(:self) do
      self
    end

    function(:locals) do
      key
    end

    function(:shared) do
      shared("args")
    end

    function(:error) do
      raise_no_method_error
    end

    function(:helper) do
      unit.helper
    end
  end

  helpers do
    def helper
      "helper"
    end
  end
end
