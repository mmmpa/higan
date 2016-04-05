require_dependency "higan/application_controller"

module Higan
  class ElementsController < ApplicationController
    def show
      @columns = klass.column_names
      @paging = true
      @elements = if elements.respond_to?(:page)
                    elements.page(page).per(per)
                  else
                    @paging = false
                    elements
                  end
    end

    def upload
      Higan.upload(
        params[:element_name].to_sym,
        force: !!params[:element][:force])
        .to(params[:element][:host].to_sym)
      redirect_to states_path
    end

    private

    def page
      params[:page] || 1
    end

    def per
      10
    end

    def klass
      Higan.element_klass(params[:element_name].to_sym)
    end

    def elements
      Higan.element_list(params[:element_name].to_sym)
    end
  end
end
