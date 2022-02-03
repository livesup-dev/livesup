defmodule LiveSup.Test.Core.Widgets.MergeStat.CommitsByAuthor.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Handler
  alias LiveSup.Core.Datasources.MergeStatDatasource

  describe "Managing MergeStat.CommitsByAuthor handler" do
    @describetag :widget
    @describetag :merge_stat_github_authors_widget
    @describetag :merge_stat_github_authors_handler

    @error {:error, "could not execute query: near \"asdf\": syntax error"}

    test "getting top n authors of a github repository" do
      with_mock MergeStatDatasource,
        run_query: fn _args -> repo_authors() end do
        data =
          %{"repo" => "https://github.com/livebook-dev/livebook", "limit" => 5}
          |> Handler.get_data()

        assert {:ok,
                %{
                  "runningTime" => 3_114_739_715,
                  "rows" => [
                    %{
                      "author_name" => "Jonatan Kłosko",
                      "count" => 341
                    },
                    %{
                      "author_name" => "jonatanklosko",
                      "count" => 123
                    },
                    %{
                      "author_name" => "José Valim",
                      "count" => 91
                    },
                    %{
                      "author_name" => "josevalim",
                      "count" => 10
                    },
                    %{
                      "author_name" => "Wojtek Mach",
                      "count" => 10
                    }
                  ],
                  "columnNames" => [
                    "author_name",
                    "count"
                  ],
                  "columnTypes" => [
                    "TEXT",
                    ""
                  ]
                }} = data
      end
    end

    test "failing getting the list of authors" do
      with_mock MergeStatDatasource,
        run_query: fn _args -> @error end do
        data =
          %{"repo" => "https://github.com/livebook-dev/livebook", "limit" => 5}
          |> Handler.get_data()

        assert {:error, "could not execute query: near \"asdf\": syntax error"} = data
      end
    end
  end

  def repo_authors() do
    {:ok,
     %{
       "runningTime" => 3_114_739_715,
       "rows" => [
         %{
           "author_name" => "Jonatan Kłosko",
           "count" => 341
         },
         %{
           "author_name" => "jonatanklosko",
           "count" => 123
         },
         %{
           "author_name" => "José Valim",
           "count" => 91
         },
         %{
           "author_name" => "josevalim",
           "count" => 10
         },
         %{
           "author_name" => "Wojtek Mach",
           "count" => 10
         }
       ],
       "columnNames" => [
         "author_name",
         "count"
       ],
       "columnTypes" => [
         "TEXT",
         ""
       ]
     }}
  end
end
