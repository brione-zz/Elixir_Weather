defmodule Weather.ParseXML do
  require Logger
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def parse(str) do
    str |> String.to_char_list |> scan_string |> parse_xml
  end

  def scan_string(str) do
    :xmerl_scan.string(str)
  end

  def parse_xml({xml, _}) do
    Logger.debug fn -> inspect xml end
    [element] = :xmerl_xpath.string('/current_observation/location', xml)
    [text] = xmlElement(element, :content)
    value = xmlText(text, :value)
    IO.inspect to_string(value)
  end

end

