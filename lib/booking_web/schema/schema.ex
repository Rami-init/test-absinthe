defmodule BookingWeb.Schema.Schema do
  alias Booking.Vacation
  alias Booking.Accounts
  use Absinthe.Schema
  import_types(BookingWeb.Schema.ContentTypes)

  query do
    @desc "query to get a place by its slug"
    field :place, :place do
      arg(:slug, non_null(:string))

      resolve(&BookingWeb.Resolvers.Vacation.get_place_by_slug/3)
    end

    @desc "query to get all places"
    field :places, list_of(:place) do
      arg(:limit, :integer, default_value: 10)
      arg(:order_by, type: :sort_order, default_value: :asc)
      arg(:filter, :place_filter)

      resolve(&BookingWeb.Resolvers.Vacation.list_places/3)
    end

    @desc "query to get current user"
    field :me, :user do
      middleware(BookingWeb.Schema.Middleware.Authenticate)
      resolve(&BookingWeb.Resolvers.Accounts.current_user/3)
    end
  end

  mutation do
    @desc "create booking for a place"
    field :create_booking, :booking do
      arg(:place_id, non_null(:id))
      arg(:start_date, non_null(:date))
      arg(:end_date, non_null(:date))
      middleware(BookingWeb.Schema.Middleware.Authenticate)
      resolve(&BookingWeb.Resolvers.Vacation.create_booking/3)
    end

    @desc "cancel a booking"
    field :cancel_booking, :booking do
      arg(:booking_id, non_null(:id))
      middleware(BookingWeb.Schema.Middleware.Authenticate)
      resolve(&BookingWeb.Resolvers.Vacation.cancel_booking/3)
    end

    @desc "create a review for a place"
    field :create_review, :review do
      arg(:review, non_null(:review_input))
      middleware(BookingWeb.Schema.Middleware.Authenticate)
      resolve(&BookingWeb.Resolvers.Vacation.create_review/3)
    end

    @desc "sign up a user"
    field :sign_up, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&BookingWeb.Resolvers.Accounts.sign_up/3)
    end

    @desc "sign in a user"
    field :sign_in, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&BookingWeb.Resolvers.Accounts.sign_in/3)
    end
  end

  subscription do
    @desc "subscription for new bookings for a place"
    field :new_booking, :booking do
      arg(:place_id, non_null(:id))

      config(fn %{place_id: place_id}, _ ->
        {:ok, topic: "place:#{place_id}"}
      end)
    end

    @desc "subscription for cancelled bookings for a place"
    field :booking_cancelled, :booking do
      arg(:place_id, non_null(:id))

      config(fn %{place_id: place_id}, _ ->
        {:ok, topic: "place:#{place_id}"}
      end)
    end
  end

  def context(ctx) do
    IO.inspect(ctx)

    loader =
      Dataloader.new()
      |> Dataloader.add_source(Vacation, Vacation.datasource())
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    ctx
    |> Map.put(:loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
