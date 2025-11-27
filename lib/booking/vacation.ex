defmodule Booking.Vacation do
  alias Booking.Repo
  import Ecto.Query
  alias Booking.Vacation.{Place, VacationBooking}

  def list_places() do
    Repo.all(Place)
  end

  def get_place_by_slug(slug) do
    Repo.get_by(Place, slug: slug)
  end

  def list_places(args) do
    Enum.reduce(args, Place, fn
      {:order_by, :asc}, query -> from(p in query, order_by: [asc: p.name])
      {:order_by, :desc}, query -> from(p in query, order_by: [desc: p.name])
      {:filter, filter}, query -> filter_places(query, filter)
      {:limit, limit}, query -> from(p in query, limit: ^limit)
      _, query -> query
    end)
    |> IO.inspect(label: "Final Query")
    |> Repo.all()
  end

  def filter_places(query, filter) do
    Enum.reduce(filter, query, fn
      {:matching, term}, query ->
        from(p in query, where: like(p.name, ^"%#{term}%") or like(p.description, ^"%#{term}%"))

      {:wifi, wifi}, query ->
        from(p in query, where: p.wifi == ^wifi)

      {:pool, pool}, query ->
        from(p in query, where: p.pool == ^pool)

      {:pet_friendly, pet_friendly}, query ->
        from(p in query, where: p.pet_friendly == ^pet_friendly)

      {:guest_count, count}, query ->
        from(p in query, where: p.max_guests >= ^count)

      {:available_between, %{start_date: start_date, end_date: end_date}}, query ->
        from(p in query,
          left_join: b in VacationBooking,
          on:
            b.place_id == p.id and
              fragment("? < ? AND ? > ?", b.start_date, ^end_date, b.end_date, ^start_date),
          where: is_nil(b.id)
        )

      _, query ->
        query
    end)
  end

  def get_booking(id) do
    Repo.get!(VacationBooking, id)
  end
end
