module ExampleUnit
  include Nyanko::Unit

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
  end
end
