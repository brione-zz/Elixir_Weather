defmodule Weather.NOAA do
  require Logger

  def fetch(location) do
    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
  end

  @the_url Application.get_env(:weather, :noaa_url)

  def noaa_url(location) do
    "#{@the_url}/#{location}.xml"
  end

  def handle_response(
      {:ok, %HTTPoison.Response{status_code: 200, body: body} }) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    Weather.ParseXML.parse body 
  end

  def handle_response({:ok,
      %HTTPoison.Response{status_code: 404}}) do
    Logger.error "Error 404 returned"
    {:error, "Not found"}
  end

  def handle_response({:error,
      %HTTPoison.Error{reason: reason}}) do
    Logger.error("Error: #{reason}")
    {:error, reason}
  end

end
