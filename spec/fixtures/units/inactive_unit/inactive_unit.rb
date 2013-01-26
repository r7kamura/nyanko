module InactiveUnit
  include Nyanko::Unit

  active_if { false }
end
