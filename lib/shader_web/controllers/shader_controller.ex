defmodule ShaderWeb.ShaderController do
  use ShaderWeb, :controller
  alias Shader.LLM

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def shader(conn, %{"prompt" => prompt}) do
    case LLM.generate_shader(prompt) do
      {:ok, shader_code} ->
        IO.puts("Generated shader for prompt: #{prompt}")
        json(conn, %{shader: shader_code})

      {:error, error} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to generate shader: #{error}"})
    end
  end
end
