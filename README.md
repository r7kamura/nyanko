# Nyanko
Nyanko is a Rails extension tool.  
This is deeply inspired from [Chanko](https://github.com/cookpad/chanko) and has same API as Chanko.

![](http://octodex.github.com/images/nyantocat.gif)


## Requirements
* Ruby >= 1.8.7
* Rails >= 3.0.10


## Install
```
$ gem install nyanko
```


## Usage

### Gemfile
```ruby
# Gemfile
gem "nyanko"
```

### Invoke
```ruby
class EntriesController < ApplicationController
  unit_action :entry_deletion, :destroy

  def index
    invoke(:entry_deletion, :index) do
      @entries = Entry.all
    end
  end
end
```

### Unit
```ruby
# app/units/entry_deletion/entry_deletion.rb
module EntryDeletion
  include Nyanko::Unit

  active_if { Rails.env.development? }

  scope(:view) do
    function(:delete_link) do
      render "/delete_link", :entry => entry if entry.persisted?
    end
  end

  scope(:controller) do
    function(:destroy) do
      entry = Entry.find(params[:id])
      entry.unit.soft_delete
      redirect_to entries_path
    end

    function(:index) do
      @entries = Entry.unit.active
    end
  end

  models do
    expand(:Entry) do
      scope :active, lambda { where(:deleted_at => nil) }

      def soft_delete
        update_attributes(:deleted_at => Time.now)
      end
    end
  end

  helpers do
    def link_to_deletion(entry)
      link_to "Delete", entry, :method => :delete
    end
  end
end
```

```
-# app/units/entry_deletion/views/_delete_link.html.slim
= unit.link_to_deletion(entry)
```


## Example App
There is an example rails application for Nyanko in spec/dummy directory.
```
$ git clone git@github.com:r7kamura/nyanko.git
$ cd nyanko/spec/dummy
$ rails s
```


## Todo
* auto-reloading
* logger
* configuration
* backwoard compatibility (alias ext to unit)
* document
* test (for now, test coverage is 100%)
