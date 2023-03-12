defmodule LiveSupWeb.Widgets.Github.GithubHelper do
  alias LiveSup.Helpers.DateHelper

  # TODO: We really need to improve the way we are
  # defining the color
  def pull_request_color(created_at) do
    number_of_days = DateHelper.diff_in_days(created_at)

    case number_of_days do
      n when n <= 3 -> "bg-gray-300"
      n when n > 20 -> "bg-red-500"
      n when n > 10 -> "bg-yellow-500"
      n when n >= 4 -> "bg-green-500"
    end
  end

  def pull_request_color(created_at, "open") do
    number_of_days = DateHelper.diff_in_days(created_at)

    case number_of_days do
      n when n <= 3 -> "bg-gray-300"
      n when n > 20 -> "bg-red-500"
      n when n > 10 -> "bg-yellow-500"
      n when n >= 4 -> "bg-green-500"
    end
  end

  def pull_request_color(created_at, "closed") do
    number_of_days = DateHelper.diff_in_days(created_at)

    case number_of_days do
      n when n <= 3 -> "bg-red-500"
      n when n > 20 -> "bg-gray-300"
      n when n > 10 -> "bg-green-500"
      n when n >= 4 -> "bg-yellow-500"
    end
  end

  def pull_request_color(created_at, element) do
    number_of_days = DateHelper.diff_in_days(created_at)

    case number_of_days do
      n when n <= 3 -> "#{element}-gray-300"
      n when n > 20 -> "#{element}-red-500"
      n when n > 10 -> "#{element}-yellow-500"
      n when n >= 4 -> "#{element}-green-500"
    end
  end

  def pull_request_bg_color(counter) do
    case counter do
      n when n <= 3 -> "dark:bg-indigo-900 dark:bg-opacity-80 bg-indigo-100 bg-opacity-60"
      n when n <= 6 -> "dark:bg-indigo-900 dark:bg-opacity-40 bg-indigo-100 bg-opacity-40"
      n when n <= 10 -> "dark:bg-indigo-900 dark:bg-opacity-20 bg-indigo-100 bg-opacity-20"
    end
  end

  def state_to_label("open"), do: "opened"
  def state_to_label("closed"), do: "closed"

  def icon("open") do
    """
    <svg fill="#3fb950" class="w-4" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M7.177 3.073L9.573.677A.25.25 0 0110 .854v4.792a.25.25 0 01-.427.177L7.177 3.427a.25.25 0 010-.354zM3.75 2.5a.75.75 0 100 1.5.75.75 0 000-1.5zm-2.25.75a2.25 2.25 0 113 2.122v5.256a2.251 2.251 0 11-1.5 0V5.372A2.25 2.25 0 011.5 3.25zM11 2.5h-1V4h1a1 1 0 011 1v5.628a2.251 2.251 0 101.5 0V5A2.5 2.5 0 0011 2.5zm1 10.25a.75.75 0 111.5 0 .75.75 0 01-1.5 0zM3.75 12a.75.75 0 100 1.5.75.75 0 000-1.5z"></path></svg>
    """
  end

  def icon("closed") do
    """
    <svg fill="#a371f7" class="w-4" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M5 3.254V3.25v.005a.75.75 0 110-.005v.004zm.45 1.9a2.25 2.25 0 10-1.95.218v5.256a2.25 2.25 0 101.5 0V7.123A5.735 5.735 0 009.25 9h1.378a2.251 2.251 0 100-1.5H9.25a4.25 4.25 0 01-3.8-2.346zM12.75 9a.75.75 0 100-1.5.75.75 0 000 1.5zm-8.5 4.5a.75.75 0 100-1.5.75.75 0 000 1.5z"></path></svg>
    """
  end
end
