require_dependency "higan/application_controller"

module Higan
  class PreviewsController < ApplicationController
    def show
      @rendered = rendered
      render layout: false
    end

    private

    def rendered
      Higan.preview(params[:element_name].to_sym, params[:element_id])
    end
  end

end
