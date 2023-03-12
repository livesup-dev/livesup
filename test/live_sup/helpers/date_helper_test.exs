defmodule LiveSup.Tests.Helpers.DateHelperTest do
  use ExUnit.Case, async: true

  alias LiveSup.Helpers.DateHelper

  describe "dealing with dates" do
    @describetag :date_helper

    test "from_now/1" do
      result = DateHelper.from_now(Timex.shift(Timex.now(), minutes: -1))

      assert result == "1 minute ago"
    end

    test "from_now/2" do
      result = DateHelper.from_now(Timex.shift(Timex.now(), minutes: -1), :short)

      assert result == "1m"

      result = DateHelper.from_now(Timex.shift(Timex.now(), months: -2), :short)

      assert result == "1mo"
    end
  end
end
