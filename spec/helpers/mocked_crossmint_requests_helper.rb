# frozen_string_literal: true

def mocked_goals_response_success(url)
  stub_request(:get, url).to_return body: goals_body_success.to_json, headers: {
    status: 200,
    content_type: 'application/json'
  }
end

# TODO
def mocked_goals_response_failed; end

def mocked_post_polyanets_response_success(url)
  stub_request(:post, url).to_return body: '{}'.to_json, headers: {
    status: 200,
    content_type: 'application/json'
  }
end

def mocked_post_polyanets_response_failed(url)
  stub_request(:post, url).to_return body: missing_parameter_error, headers: {
    status: 400,
    content_type: 'application/json'
  }
end

def mocked_delete_polyanets_response_success(url)
  stub_request(:delete, url).to_return body: '{}'.to_json, headers: {
    status: 200,
    content_type: 'application/json'
  }
end

# TODO
def mocked_delete_polyanets_response_failed; end

def missing_parameter_error
  {
    error: true,
    message: 'Missing parameters. The API accepts parameters as JSON, and remember to specify the proper Content-Type'
  }
end

def goals_body_success
  {
    "goal": [
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "POLYANET",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ],
        [
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE",
            "SPACE"
        ]
    ]
  }
end
