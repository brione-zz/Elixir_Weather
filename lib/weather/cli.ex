#---
# Excerpted from "Programming Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/elixir for more book information.
#---
defmodule Weather.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a 
  table of NOAA weather data for the specified location code.
  """
  def run(argv) do
    argv 
      |> parse_args 
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ location }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case  parse  do

    { [ help: true ], _, _ } 
      -> :help

    { _, [ location, count ], _ }  
      -> { location,  String.to_integer(count) }

    { _, [ location ], _ } 
      -> { location, @default_count }

    _ -> :help

    end
  end

  def process(:help) do
    IO.puts """
    usage:  weather <location> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({location, _count}) do
    Weather.NOAA.fetch(location)
  end

end

