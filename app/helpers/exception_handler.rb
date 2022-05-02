# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from :all do |e|
      case e.class.name
      when 'ActiveRecord::RecordNotFound'
        error!(e.message, 404)
      when 'ActiveRecord::RecordInvalid', 'ArgumentError'
        error!(e.message, 500)
      when 'Grape::Exceptions::ValidationErrors'
        error!(e.full_messages, 406)
      else
        error!('Bad request', 400)
      end
    end
  end
end
