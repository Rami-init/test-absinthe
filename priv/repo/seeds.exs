# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Booking.Repo.insert!(%Booking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Booking.Repo
alias Booking.Vacation.{Place, Review}
alias Booking.Vacation.VacationBooking
alias Booking.Accounts.User

users = [
  %{
    email: "user1@example.com",
    password: "password123456"
  },
  %{
    email: "user2@example.com",
    password: "password123456"
  },
  %{
    email: "user3@example.com",
    password: "password123456"
  }
]

Enum.each(users, fn user_attrs ->
  %User{}
  |> User.registration_changeset(user_attrs)
  |> Repo.insert!()
end)

places = [
  %{
    name: "Beachside Bungalow",
    slug: "beachside-bungalow",
    description: "A cozy bungalow right on the beach.",
    location: "Malibu, CA",
    price_per_night: Decimal.from_float(253.00),
    image: "https://picsum.photos/id/1018/400/300",
    image_thumbnail: "https://picsum.photos/id/1018/100/75",
    max_guests: 4,
    pet_friendly: true,
    pool: false,
    wifi: true
  },
  %{
    name: "Mountain Cabin Retreat",
    slug: "mountain-cabin-retreat",
    description: "A rustic cabin nestled in the mountains.",
    location: "Aspen, CO",
    price_per_night: Decimal.from_float(300.00),
    image: "https://picsum.photos/id/1019/400/300",
    image_thumbnail: "https://picsum.photos/id/1019/100/75",
    max_guests: 6,
    pet_friendly: false,
    pool: true,
    wifi: true
  },
  %{
    name: "City Center Apartment",
    slug: "city-center-apartment",
    description: "A modern apartment in the heart of the city.",
    location: "New York, NY",
    price_per_night: Decimal.from_float(200.00),
    image: "https://picsum.photos/id/1020/400/300",
    image_thumbnail: "https://picsum.photos/id/1020/100/75",
    max_guests: 2,
    pet_friendly: false,
    pool: false,
    wifi: true
  },
  %{
    name: "Countryside Villa",
    slug: "countryside-villa",
    description: "A spacious villa in the peaceful countryside.",
    location: "Tuscany, Italy",
    price_per_night: Decimal.from_float(400.00),
    image: "https://picsum.photos/id/1021/400/300",
    image_thumbnail: "https://picsum.photos/id/1021/100/75",
    max_guests: 8,
    pet_friendly: true,
    pool: true,
    wifi: true
  },
  %{
    name: "Desert Oasis",
    slug: "desert-oasis",
    description: "A luxurious oasis in the middle of the desert.",
    location: "Phoenix, AZ",
    price_per_night: Decimal.from_float(350.00),
    image: "https://picsum.photos/id/1022/400/300",
    image_thumbnail: "https://picsum.photos/id/1022/100/75",
    max_guests: 5,
    pet_friendly: false,
    pool: true,
    wifi: true
  },
  %{
    name: "Lakeside Cottage",
    slug: "lakeside-cottage",
    description: "A charming cottage by the lake.",
    location: "Lake Tahoe, CA",
    price_per_night: Decimal.from_float(275.00),
    image: "https://picsum.photos/id/1023/400/300",
    image_thumbnail: "https://picsum.photos/id/1023/100/75",
    max_guests: 4,
    pet_friendly: true,
    pool: false,
    wifi: true
  },
  %{
    name: "Tropical Treehouse",
    slug: "tropical-treehouse",
    description: "A unique treehouse experience in the tropics.",
    location: "Costa Rica",
    price_per_night: Decimal.from_float(320.00),
    image: "https://picsum.photos/id/1024/400/300",
    image_thumbnail: "https://picsum.photos/id/1024/100/75",
    max_guests: 3,
    pet_friendly: false,
    pool: false,
    wifi: true
  },
  %{
    name: "Historic Castle",
    slug: "historic-castle",
    description: "Stay in a medieval castle with modern amenities.",
    location: "Edinburgh, Scotland",
    price_per_night: Decimal.from_float(500.00),
    image: "https://picsum.photos/id/1025/400/300",
    image_thumbnail: "https://picsum.photos/id/1025/100/75",
    max_guests: 10,
    pet_friendly: false,
    pool: true,
    wifi: true
  },
  %{
    name: "Ski Chalet",
    slug: "ski-chalet",
    description: "A cozy chalet perfect for ski trips.",
    location: "Whistler, Canada",
    price_per_night: Decimal.from_float(450.00),
    image: "https://picsum.photos/id/1026/400/300",
    image_thumbnail: "https://picsum.photos/id/1026/100/75",
    max_guests: 6,
    pet_friendly: true,
    pool: false,
    wifi: true
  }
]

Enum.each(places, fn place_attrs ->
  %Place{}
  |> Place.changeset(place_attrs)
  |> Repo.insert!()
end)

# Get the created users for reviews
users_from_db = Repo.all(User)

reviews = [
  %{
    rating: 5,
    comment: "Amazing place! Had a wonderful time.",
    user_id: 1,
    place_id: 1
  },
  %{
    rating: 4,
    comment: "Great location but a bit noisy at night.",
    user_id: 2,
    place_id: 1
  },
  %{
    rating: 5,
    comment: "Perfect location for skiing! The chalet was warm and inviting.",
    user_id: 2,
    place_id: 4
  },
  %{
    rating: 3,
    comment: "Average experience, nothing special.",
    user_id: 3,
    place_id: 2
  },
  %{
    rating: 5,
    comment: "Absolutely loved it! Will come back again.",
    user_id: 1,
    place_id: 3
  },
  %{
    rating: 2,
    comment: "Not as expected, needs improvement.",
    user_id: 2,
    place_id: 4
  },
  %{
    rating: 4,
    comment: "Very comfortable and clean.",
    user_id: 3,
    place_id: 5
  }
]

Enum.each(reviews, fn review_attrs ->
  user = Enum.find(users_from_db, &(&1.id == review_attrs.user_id))

  %Review{}
  |> Review.changeset(review_attrs, %{user: user})
  |> Repo.insert!()
end)

bookings = [
  %{
    start_date: ~D[2024-12-20],
    end_date: ~D[2024-12-27],
    state: "confirmed",
    total_price: Decimal.from_float(1750.00),
    place_id: 1,
    user_id: 1
  },
  %{
    start_date: ~D[2025-01-10],
    end_date: ~D[2025-01-15],
    state: "pending",
    total_price: Decimal.from_float(1500.00),
    place_id: 2,
    user_id: 2
  },
  %{
    start_date: ~D[2025-02-05],
    end_date: ~D[2025-02-12],
    state: "cancelled",
    total_price: Decimal.from_float(2100.00),
    place_id: 3,
    user_id: 3
  }
]

Enum.each(bookings, fn booking_attrs ->
  user = Enum.find(users_from_db, &(&1.id == booking_attrs.user_id))

  %VacationBooking{}
  |> VacationBooking.changeset(booking_attrs, %{user: user})
  |> Repo.insert!()
end)
