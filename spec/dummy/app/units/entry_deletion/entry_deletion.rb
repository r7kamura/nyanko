module EntryDeletion
  include Nyanko::Unit

  scope(:view) do
    function(:delete_link) do
      render "/delete_link", :entry => entry if entry.persisted?
    end
  end
end
