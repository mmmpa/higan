require_dependency "higan/application_controller"

module Higan
  class ElementsController < ApplicationController
    def show
      @columns = klass.column_names
      @elements = elements
    end

    private

    def klass
      Higan.element_klass(params[:element_name].to_sym)
    end

    def elements
      Higan.element_list(params[:element_name].to_sym)
    end
  end
end
