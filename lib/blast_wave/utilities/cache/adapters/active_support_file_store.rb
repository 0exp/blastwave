# frozen_string_literal: true

module Rack
  module BlastWave::Utilities::Cache::Adapters
    # @api private
    # @since 0.1.0
    class ActiveSupportFileStore < ActiveSupportNaiveStore
      require_relative 'active_support_file_store/fetching'
      require_relative 'active_support_file_store/operation'
      require_relative 'active_support_file_store/increment'
      require_relative 'active_support_file_store/decrement'
      require_relative 'active_support_file_store/re_expire'

      class << self
        # @param driver [Object]
        # @return [Boolean]
        #
        # @api private
        # @since 0.1.0
        def supported_driver?(driver)
          defined?(::ActiveSupport::Cache::FileStore) &&
          driver.is_a?(::ActiveSupport::Cache::FileStore)
        end
      end
    end
  end
end
