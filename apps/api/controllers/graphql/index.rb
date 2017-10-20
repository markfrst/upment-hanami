# frozen_string_literal: true

module Api::Controllers::Graphql
  class Index
    include Api::Action
    before :restructure_variables

    params do
      required(:query) { filled? & str? }
      optional(:variables).maybe(:hash?)
    end

    def call(params)
      halt 400 unless params.valid?

      jwt = Authentication::Tokens.new(request.get_header('HTTP_AUTHORIZATION') || '')
      headers['authorization'] = jwt.new_header_token if jwt.authorized?

      status 200, Schema.execute(params[:query],
                                 variables: @variables,
                                 context: { current_user: jwt.user }).to_json
    end

    private

    def restructure_variables(params)
      @variables = Hanami::Utils::Hash.new(params[:variables] || {})
      @variables.stringify!
    end

    def verify_csrf_token?
      false
    end
  end
end
