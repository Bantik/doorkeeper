module Doorkeeper
  class TokensController < ActionController::Metal
    include Helpers::Controller
    include ActionController::RackDelegation
    include ActionController::Instrumentation

    def create
      response = strategy.authorize
      self.headers.merge! response.headers
      self.response_body = response.body.to_json
      self.status        = response.status
      render :text => self.inspect
    # rescue Errors::DoorkeeperError => e
    #   handle_token_exception e
    end

  private

    def strategy
      @strategy ||= server.token_request params[:grant_type]
    end
  end
end
