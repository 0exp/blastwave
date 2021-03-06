# frozen_string_literal: true

# rubocop:disable RSpec/Focus
if SpecSupport::Testing.test_redis_cache?
  require_relative 'cache_utility_common_behaviour_examples'

  describe 'Cache utility => Storage: Redis', :focus do
    driver = SpecSupport::Cache::Redis.connect

    it_behaves_like 'Cache utility => Common behaviour' do
      let!(:cache_storage) { Rack::BlastWave::Utilities::Cache.build(driver) }
    end
  end
end
# rubocop:enable RSpec/Focus
