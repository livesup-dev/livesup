defmodule LiveSupWeb.Widgets.Github.GithubHelper do
  alias LiveSup.Helpers.DateHelper

  def pull_request_color(created_at) do
    number_of_days = DateHelper.diff_in_days(created_at)

    case number_of_days do
      n when n <= 3 -> "bg-gray-300"
      n when n > 20 -> "bg-red-500"
      n when n > 10 -> "bg-yellow-500"
      n when n >= 4 -> "bg-green-500"
    end
  end

  def pull_request_bg_color(counter) do
    case counter do
      n when n <= 3 -> "dark:bg-indigo-900 dark:bg-opacity-80 bg-indigo-100 bg-opacity-60"
      n when n <= 6 -> "dark:bg-indigo-900 dark:bg-opacity-40 bg-indigo-100 bg-opacity-40"
      n when n <= 10 -> "dark:bg-indigo-900 dark:bg-opacity-20 bg-indigo-100 bg-opacity-20"
    end
  end
end
