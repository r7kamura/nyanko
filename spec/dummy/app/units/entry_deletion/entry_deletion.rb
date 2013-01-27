module EntryDeletion
  include Nyanko::Unit

  scope(:view) do
    function(:delete_link) do
      render "/delete_link", :entry => entry if entry.persisted?
    end
  end

  scope(:controller) do
    function(:destroy) do
      entry = Entry.find(params[:id])
      entry.destroy
      redirect_to entries_path
    end
  end
end
