require_dependency "higan/application_controller"

module Higan
  class StatesController < ApplicationController
    def index
      @ftp_data = Higan.ftp_data
      @local_data = Higan.local_data
      @element_data = Higan.element_data
    end
  end
end
