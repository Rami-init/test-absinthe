defmodule BookingWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

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
end
