class Rack::Attack
  throttle('api_search/ip', limit: 10, period: 10.seconds) do |req|
    req.ip if req.path.start_with?('/api/v1/jobs/search') && req.get?
  end
  self.throttled_response = lambda do |env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded. Please wait a few seconds before searching again.' }.to_json]
    ]
  end
end
