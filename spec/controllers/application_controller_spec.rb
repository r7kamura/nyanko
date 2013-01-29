require "spec_helper"

describe ApplicationController do
  controller do
    def index
      head 200
    end
  end

  it "clears cache before each request" do
    Nyanko::Loader.cache.should_receive(:clear).exactly(2)
    get :index
    get :index
  end
end
