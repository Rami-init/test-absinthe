defmodule Booking.Vacation do
  alias Booking.Repo
  import Ecto.Query
  alias Booking.Accounts.User
  alias Booking.Vacation.{Place, VacationBooking, Review}

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

  def list_bookings_for_place(%Place{} = place) do
    VacationBooking |> where(place_id: ^place.id) |> where(state: "confirmed") |> Repo.all()
  end

  def create_booking(%User{} = user, attrs) do
    user_scope = %{user: user}

    %VacationBooking{}
    |> VacationBooking.changeset(attrs, user_scope)
    |> Repo.insert()
  end

  def cancel_booking(%VacationBooking{} = booking) do
    booking
    |> VacationBooking.changeset(%{state: "cancelled"}, %{user: %User{id: booking.user_id}})
    |> Repo.update()
  end

  def create_review(%User{} = user, attrs) do
    user_scope = %{user: user}

    %Review{}
    |> Review.changeset(attrs, user_scope)
    |> Repo.insert()
  end

  def datasource do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(VacationBooking, %{scope: :place}),
    do: from(b in VacationBooking, where: b.state == "confirmed", order_by: [desc: b.start_date])

  def query(queryable, _params), do: queryable
end
