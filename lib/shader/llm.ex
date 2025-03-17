defmodule Shader.LLM do
  @moduledoc """
  Handles interactions with the Language Learning Model for shader generation
  """

  @default_system_prompt """
  You are an expert web developer with expertise in webGL.
  Your task is to generate a shader code snippet for fragment shader that will be used to render the object on screen.
  You will be given a description of the shader that you need to generate.
  Use these variables in your code for uniformity:
  - aVertexPosition
  - uTime
  - uResolution
  """

  @model "claude-3-7-sonnet-20250219"

  @spec generate_shader(any()) :: {:error, binary()} | {:ok, binary()}
  def generate_shader(prompt) do
    try do
      message = "Create a fragment shader with the following description\n: #{prompt}

      FOLLOW THESE RULES:
      - Use webGL2 syntax only.
      - The output should be a valid code snippet for a fragment shader.
      - Respond with <reason></reason><fragment_shader></fragment_shader> as xml tags
      "

      # Make the Anthropix call
      client = Anthropix.init(api_key: Application.get_env(:anthropix, :api_key))

      case Anthropix.chat(client,
             model: @model,
             system: @default_system_prompt,
             messages: [%{role: "user", content: message}]
           ) do
        {:ok, response} ->
          content =
            case response do
              %{"content" => [%{"text" => text, "type" => "text"} | _]} -> text
              %{content: [%{text: text, type: "text"} | _]} -> text
              %{content: content} when is_binary(content) -> content
              %{"content" => content} when is_binary(content) -> content
              _ -> raise "Unexpected response format: #{inspect(response)}"
            end

          case Regex.run(~r/<fragment_shader>(.*?)<\/fragment_shader>/s, content) do
            [_, shader_code] ->
              {:ok, String.trim(shader_code)}

            nil ->
              {:error, "Could not extract fragment shader from response"}
          end

        {:error, reason} ->
          {:error, "LLM request failed: #{inspect(reason)}"}
      end
    rescue
      e -> {:error, Exception.message(e)}
    end
  end
end
