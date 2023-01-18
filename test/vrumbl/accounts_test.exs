defmodule Vrumbl.AccountsTest do
  use Vrumbl.DataCase, async: true

  alias Vrumbl.Accounts
  alias Vrumbl.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "foo",
      username: "Foo",
      password: "secret"
    }

    @invalid_attrs %{}

    test "inserts with valid data" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "foo"
      assert user.username == "Foo"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 21))
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
      assert Accounts.list_users() == []
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "123456"
    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, my_user} = Accounts.authenticate_by_login(user.username, @pass)
      assert my_user.id == user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} = Accounts.authenticate_by_login(user.username, "badpass")
    end

    test "returns not found error with no matching user for username" do
      assert {:error, :not_found} = Accounts.authenticate_by_login("unknownuser", @pass)
    end
  end
end
