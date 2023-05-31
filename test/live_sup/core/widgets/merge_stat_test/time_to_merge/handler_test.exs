defmodule LiveSup.Test.Core.Widgets.MergeStat.TimeToMerge.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.MergeStat.TimeToMerge.Handler
  alias LiveSup.Core.Datasources.MergeStatDatasource

  describe "Managing MergeStat.TimeToMerge handler" do
    @describetag :widget
    @describetag :merge_stat_github_time_to_merge_widget
    @describetag :merge_stat_github_time_to_merge_handler

    test "time to merge" do
      with_mock MergeStatDatasource,
        time_to_merge: fn _repo, _params -> time_to_merge_data() end do
        data =
          %{"repos" => "repo1,repo2,repo3,repo4"}
          |> Handler.get_data()

        assert {
                 :ok,
                 [
                   %{
                     "avg_days_to_merge" => "6.24",
                     "label" => "billing-it",
                     "repo" => "https://github.com/livesup/billing-it"
                   },
                   %{
                     "avg_days_to_merge" => "3.61",
                     "label" => "embs",
                     "repo" => "https://github.com/livesup/embs"
                   },
                   %{
                     "avg_days_to_merge" => "3.41",
                     "label" => "kb-deploy",
                     "repo" => "https://github.com/livesup/kb-deploy"
                   },
                   %{
                     "avg_days_to_merge" => "2.21",
                     "label" => "api",
                     "repo" => "https://github.com/livesup/api"
                   },
                   %{
                     "avg_days_to_merge" => "1.68",
                     "label" => "billing-api",
                     "repo" => "https://github.com/livesup/billing-api"
                   }
                 ]
               } = data
      end
    end
  end

  def time_to_merge_data() do
    {:ok,
     [
       %{
         "avg_days_to_merge" => "6.24",
         "repo" => "https://github.com/livesup/billing-it"
       },
       %{"avg_days_to_merge" => "3.61", "repo" => "https://github.com/livesup/embs"},
       %{"avg_days_to_merge" => "3.41", "repo" => "https://github.com/livesup/kb-deploy"},
       %{"avg_days_to_merge" => "2.21", "repo" => "https://github.com/livesup/api"},
       %{
         "avg_days_to_merge" => "1.68",
         "repo" => "https://github.com/livesup/billing-api"
       }
     ]}
  end
end
