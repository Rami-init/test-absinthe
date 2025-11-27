defmodule BookingWeb.Schema.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import_types(BookingWeb.Schema.ContentTypes)

  query do
    @desc "query to get a place by its slug"
    field :place, :place do
      arg(:slug, non_null(:string))

      resolve(fn _, %{slug: slug}, _ ->
        case Booking.Vacation.get_place_by_slug(slug) do
          nil -> {:error, "Place not found"}
          place -> {:ok, place}
        end
      end)
    end

    @desc "query to get all places"
    field :places, list_of(:place) do
      arg(:limit, :integer, default_value: 10)
      arg(:order_by, type: :sort_order, default_value: :asc)
      arg(:filter, :place_filter)

      resolve(fn _, args, _ ->
        places = Booking.Vacation.list_places(args)
        {:ok, places}
      end)
    end
  end
end
