require "spec_helper"

describe ApplicationController do
  controller do
    def index
      head 200
    end
  end

  it "clears unit const cache before each request" do
    Nyanko::Loader.const_cache.should_receive(:clear).exactly(2)
    get :index
    get :index
  end
end
