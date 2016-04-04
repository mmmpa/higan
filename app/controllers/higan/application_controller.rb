module Higan
  class ApplicationController < ActionController::Base
    before_action -> { Higan.configure! }
  end
end
