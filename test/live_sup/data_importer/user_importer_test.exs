defmodule LiveSup.Test.DataImporter.UserImporterTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.{Users, Groups}

  describe "Import from a yaml file" do
    @describetag :importer_user

    setup [:setup_groups]

    test "data is imported" do
      assert Users.count() == 0
      assert Groups.count() == 2

      yaml_data()
      |> LiveSup.DataImporter.UserImporter.perform()

      assert Users.count() == 2

      emi = Users.get("da4aeab3-bb2b-48c0-8e81-f129242ed42e")
      assert emi.first_name == "Emiliano"
      assert emi.last_name == "Dumont"
      assert emi.email == "emiliano@livesup.com"

      # re run the import to make sure we don't duplicate data
      yaml_data()
      |> LiveSup.DataImporter.UserImporter.perform()

      assert Users.count() == 2
    end
  end

  describe "importing data when we already have data" do
    @describetag :importer_user

    setup [:setup_groups, :setup_user]

    test "data is cleaned and imported" do
      assert Users.count() == 1
      assert Groups.count() == 2

      yaml_clean()
      |> LiveSup.DataImporter.UserImporter.perform()

      assert Users.count() == 2

      emi = Users.get_with_groups("da4aeab3-bb2b-48c0-8e81-f129242ed42e")
      assert emi.first_name == "Emiliano"
      assert emi.last_name == "Dumont"
      assert emi.email == "emiliano@livesup.com"

      assert length(emi.groups) == 2
    end
  end

  defp yaml_clean do
    """
    remove_existing_users: true
    users:
      - id: da4aeab3-bb2b-48c0-8e81-f129242ed42e
        first_name: Emiliano
        last_name: Dumont
        avatar_url: https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/5a390ef9280a8d389404eebe/53550071-f045-44f3-bc75-96956f8541c3/48
        email: emiliano@livesup.com
        password: Very@Safe@Password
    """
  end

  defp yaml_data do
    """
    users:
      - id: da4aeab3-bb2b-48c0-8e81-f129242ed42e
        first_name: Emiliano
        last_name: Dumont
        avatar_url: https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/5a390ef9280a8d389404eebe/53550071-f045-44f3-bc75-96956f8541c3/48
        email: emiliano@livesup.com
        password: Very@Safe@Password
      - id: c7bdf25e-2f7b-498a-82fc-f2f6279943a6
        first_name: John
        last_name: Doe
        avatar_url: https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/5a390ef9280a8d389404eebe/53550071-f045-44f3-bc75-96956f8541c3/48
        email: john@livesup.com
        password: Very@Safe@Password
    """
  end
end
