require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def get_image_data
      # APIのURL作成
      api_url = "https://api.pay.jp/v1/charges"

      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          card: '',
          amount: 1000,
          currency: 'jpy'
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      #request.basic_auth("user", "sk_test_c62fade9d045b54cd76d7036")
      request['user_agent'] = "Payjp/v1 RubyBindings/#{Payjp::VERSION}"
      request['Authorization'] = "Basic #{Base64.strict_encode64("#{ENV['PAYJP_SECRET_KEY']}:")}"
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      puts request.inspect
      puts response_body
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      # APIレスポンス出力
      if (error = response_body['error']).present?
        raise error
      else
        response_body['responses'][0]['labelAnnotations'].pluck('description').take(3)
      end
    end
  end
end