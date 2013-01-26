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
  end
end
