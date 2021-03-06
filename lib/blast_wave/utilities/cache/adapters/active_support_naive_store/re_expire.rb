# frozen_string_literal: true

module Rack
  class BlastWave::Utilities::Cache::Adapters::ActiveSupportNaiveStore
    # @api private
    # @since 0.1.0
    class ReExpire < Operation
      # @param key [String]
      # @option expires_in [Integer, NilClass]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def call(key, expires_in: NO_EXPIRATION_TTL)
        fetch_entry(key).tap do |entry|
          write(key, entry.value, expires_in: expires_in) if entry
        end
      end

      # @!method fetch_entry(key)
      #   @param key [String]
      #   @return [NilClass, ActiveSupport::Cache::Entry]
    end
  end
end
