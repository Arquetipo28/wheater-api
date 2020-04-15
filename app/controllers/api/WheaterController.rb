# frozen_string_literal: true

module Api
  class WheaterController < ApplicationController
    def show_min
      found_min_temp = min_temperature
      render json: { message: 'successfully returned min wheater', data: { value: found_min_temp } }, status: :ok
    rescue ActiveRecord::RecordNotFound => error
      render json: { message: 'not min wheater found', error: error }, status: :no_content
    end

    def show
      temp_order = params[:temp]
      date_order = params[:created_at]
      raise 'No valid order filter' unless valid_order_filter?(temp_order, date_order)

      wheater_collection = Wheater.all
      ordered_wheater = order_by(wheater_collection, 'temp', temp_order)
      ordered_wheater = order_by(ordered_wheater, 'created_at', date_order)
      render json: { message: 'successfully returned historical wheater', data: { wheater: wheater_collection } }
    rescue StandardError => e
      render json: { message: e }
    end

    private

    def min_temperature
      Wheater.order(temp: :asc).first!
    end

    def valid_order_filter?(temp_order, date_order)
      valid_temp_order = temp_order ? temp_order.match?(/desc|asc|DESC|ASC/) : true
      valid_date_order = date_order ? date_order.match?(/desc|asc|DESC|ASC/) : true
      valid_date_order && valid_temp_order
    end

    def order_by(resource, field, order)
      return resource unless order

      resource.order(field.to_sym => order )
    end
  end
end
