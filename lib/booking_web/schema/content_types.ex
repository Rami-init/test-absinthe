defmodule BookingWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation
  import_types(Absinthe.Type.Custom)

  alias Booking.Vacation
  alias Booking.Accounts
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  object :place do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :slug, non_null(:string)
    field :description, non_null(:string)
    field :location, non_null(:string)
    field :price_per_night, non_null(:decimal)
    field :image, non_null(:string)
    field :image_thumbnail, non_null(:string)
    field :max_guests, non_null(:integer)
    field :pet_friendly, non_null(:boolean)
    field :pool, non_null(:boolean)
    field :wifi, non_null(:boolean)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)

    field :bookings, list_of(:booking) do
      resolve(dataloader(Vacation, :bookings, args: %{scope: :place}))
    end

    field :reviews, list_of(:review), resolve: dataloader(Vacation)
  end

  object :booking do
    field :id, non_null(:id)
    field :place_id, non_null(:id)
    field :start_date, non_null(:date)
    field :end_date, non_null(:date)
    field :state, non_null(:string)
    field :total_price, non_null(:decimal)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)

    field :user, non_null(:user), resolve: dataloader(Accounts)
    field :place, non_null(:place), resolve: dataloader(Vacation)
  end

  object :review do
    field :id, non_null(:id)
    field :place_id, non_null(:id)
    field :rating, non_null(:integer)
    field :comment, non_null(:string)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)

    field :user, non_null(:user), resolve: dataloader(Accounts)
    field :place, non_null(:place), resolve: dataloader(Vacation)
  end

  object :session do
    field :user, non_null(:user)
    field :token, non_null(:string)
  end

  object :user do
    field :email, non_null(:string)

    field :bookings, list_of(:booking), resolve: dataloader(Vacation)
    field :reviews, list_of(:review), resolve: dataloader(Vacation)
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  input_object :place_filter do
    field :matching, :string
    field :wifi, :boolean
    field :pool, :boolean
    field :pet_friendly, :boolean
    field :guest_count, :integer
    field :available_between, :date_range
  end

  input_object :date_range do
    field :start_date, non_null(:date)
    field :end_date, non_null(:date)
  end

  input_object :review_input do
    field :place_id, non_null(:id)
    field :rating, non_null(:integer)
    field :comment, non_null(:string)
  end
end
