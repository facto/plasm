defmodule Plasm.OnTest do
  use Plasm.Case

  alias Plasm.Repo
  alias Plasm.User

  import Plasm.Factory

  test ".on with an Ecto.Date" do
    # Arrange
    castable_string = "2016-07-27"
    earlier_user = insert(:user, inserted_at: "2016-07-26T00:00:00Z")
    exact_match_user = insert(:user, inserted_at: castable_string <> "T14:00:00Z")
    later_user = insert(:user, inserted_at: "2016-07-28T00:00:00Z")

    # Act
    user_ids = User |> Plasm.on(:inserted_at, Ecto.Date.cast!(castable_string)) |> Repo.all() |> Enum.map(&(&1.id))

    # Assert
    assert Enum.member?(user_ids, exact_match_user.id)
    refute Enum.member?(user_ids, later_user.id)
    refute Enum.member?(user_ids, earlier_user.id)
  end

  test ".on with a castable Ecto.Date" do
    # Arrange
    castable_string = "2016-07-27"
    earlier_user = insert(:user, inserted_at: "2016-07-26T00:00:00Z")
    exact_match_user = insert(:user, inserted_at: castable_string <> "T00:00:00Z")
    later_user = insert(:user, inserted_at: "2016-07-28T00:00:00Z")

    # Act
    user_ids = User |> Plasm.on(:inserted_at, castable_string) |> Repo.all() |> Enum.map(&(&1.id))

    # Assert
    assert Enum.member?(user_ids, exact_match_user.id)
    refute Enum.member?(user_ids, later_user.id)
    refute Enum.member?(user_ids, earlier_user.id)
  end
end
