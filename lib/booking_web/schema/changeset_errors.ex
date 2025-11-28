defmodule BookingWeb.Schema.ChangesetErrors do
  def errors_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", stringify_value(value))
      end)
    end)
  end

  defp stringify_value(value) when is_list(value) do
    Enum.join(value, ", ")
  end

  defp stringify_value(value) do
    to_string(value)
  end
end
