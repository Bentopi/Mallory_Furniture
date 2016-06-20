require 'csv'

class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :load_categories

    class Product
        attr_accessor :id, :name, :description, :price, :condition, :dimensions, :photo, :quantity, :category
        def initialize(id, name, description, price, condition, dimensions, photo, quantity, category)
            @id = id
            @name = name
            @description = description
            @price = price
            @condition = condition
            @dimensions = dimensions
            @photo = photo
            @quantity = quantity
            @category = category
        end
    end
    def fetch_products
        product_list = []

        CSV.foreach("#{Rails.root}/mf_inventory.csv", headers: true) do |row|
            product_hash = row.to_hash
            id = product_hash['pid']
            name = product_hash['item']
            description = product_hash['description']
            price = product_hash['price'].to_i
            condition = product_hash['condition']
            dimensions = [product_hash['dimension_w'], product_hash['dimension_l'], product_hash['dimension_h']]
            photo = product_hash['img_file']
            quantity = product_hash['quantity']
            category = product_hash['category']
            product = Product.new id, name, description, price, condition, dimensions, photo, quantity, category
            product_list << product
        end
        product_list
    end

    def fetch_categories(product_list)
      categories = product_list.map(&:category)
      categories.uniq
    end

    def load_categories
      product_list = fetch_products
      @unique_categories = fetch_categories(product_list)
    end
end
