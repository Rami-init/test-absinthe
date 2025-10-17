defmodule Booking.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :start_date, :date
      add :end_date, :date
      add :state, :string
      add :total_price, :decimal
      add :place_id, references(:places, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:user_id])

    create index(:bookings, [:place_id])
  end
end
