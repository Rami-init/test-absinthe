defmodule BookingWeb.Schema.Schema do
  use Absinthe.Schema
  #  doc """
  #  The main schema for the BookingWeb application.
  #  It defines the GraphQL types, queries, and mutations.
  #  """
  query do
    field :hello, :string do
      resolve(fn _, _ -> {:ok, "Hello, world!"} end)
    end
  end
end
