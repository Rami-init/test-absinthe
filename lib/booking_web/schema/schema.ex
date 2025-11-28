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
  end

  mutation do
    @desc "create booking for a place"
    field :create_booking, :booking do
      arg(:place_id, non_null(:id))
      arg(:start_date, non_null(:date))
      arg(:end_date, non_null(:date))
      resolve(&BookingWeb.Resolvers.Vacation.create_booking/3)
    end

    @desc "cancel a booking"
    field :cancel_booking, :booking do
      arg(:booking_id, non_null(:id))
      resolve(&BookingWeb.Resolvers.Vacation.cancel_booking/3)
    end

    @desc "create a review for a place"
    field :create_review, :review do
      arg(:review, non_null(:review_input))
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

  def context(ctx) do
    current_user = Booking.Accounts.get_user_by_email("user1@example.com")

    loader =
      Dataloader.new()
      |> Dataloader.add_source(Vacation, Vacation.datasource())
      |> Dataloader.add_source(Accounts, Accounts.datasource())

    ctx
    |> Map.put(:current_user, current_user)
    |> Map.put(:loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
