class Wrapper
  def initialize(app)
    @app = app
  end

  def call(env)
    status_match = env["QUERY_STRING"].match(/status=(\d+)/)
    status_code = (status_match) ? status_match[1].to_i : 0

    if status_code >= 400
      [status_code, {"Content-Type" => "text/plain"}, ["Here's your error code!\n"]]
    else
      @app.call(env)
    end
  end
end
