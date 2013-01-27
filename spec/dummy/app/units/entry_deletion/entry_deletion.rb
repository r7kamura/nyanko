module EntryDeletion
  include Nyanko::Unit

  scope(:view) do
    function(:delete_link) do
      link_to "Delete", entry_path(entry), :method => :delete unless entry.persisted?
    end
  end
end
