require 'csv'

class ProductsController < ApplicationController
    def list
        @product_list = fetch_products
        product = @product_list.find { |p| p.id == params[:id] }
    end
    def detail
        product_list = fetch_products
        @product = product_list.find { |p| p.id == params[:id] }
    end
end
