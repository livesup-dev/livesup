defmodule LiveSup.Test.Core.Widgets.MergeStat.CommitsByAuthor.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Handler
  alias LiveSup.Core.Datasources.MergeStatDatasource
  alias LiveSup.Schemas.{LinkSchemas, WidgetInstance}
  alias LiveSup.Test.AccountsFixtures
  alias LiveSup.Core.Widgets.WidgetContext

  describe "Managing MergeStat.CommitsByAuthor handler" do
    @describetag :widget
    @describetag :merge_stat_github_authors_widget
    @describetag :merge_stat_github_authors_handler

    @error {:error, "could not execute query: near \"asdf\": syntax error"}

    setup do
      user = AccountsFixtures.user_fixture()

      %{datasource_instance: datasource_instance} =
        LiveSup.Test.LinksFixtures.add_github_link(user, %LinkSchemas.Github{
          username: "mustela"
        })

      widget_context =
        WidgetContext.build(
          %WidgetInstance{datasource_instance: datasource_instance},
          user
        )

      %{widget_context: widget_context}
    end

    test "getting top n authors of a github repository", %{widget_context: widget_context} do
      with_mock MergeStatDatasource,
        commits_by_author: fn _repo, _params -> repo_authors() end do
        data =
          %{"repo" => "https://github.com/livebook-dev/livebook", "limit" => 5}
          |> Handler.get_data(widget_context)

        assert {:ok,
                [
                  %{
                    "author_email" => "ejankowski@gmail.com",
                    "author_name" => "mustela",
                    "count" => "296"
                  },
                  %{
                    "author_email" => "guillermo@dinkuminteractive.com",
                    "author_name" => "Memo",
                    "count" => "47"
                  },
                  %{
                    "author_email" => "ejankowski@gmail.com",
                    "author_name" => "Emiliano Jankowski",
                    "count" => "11"
                  },
                  %{
                    "author_email" => "49699333+dependabot[bot]@users.noreply.github.com",
                    "author_name" => "dependabot[bot]",
                    "count" => "8"
                  },
                  %{
                    "author_email" => "pierre@mouraf.org",
                    "author_name" => "Pierre-Alexandre Meyer",
                    "count" => "1"
                  }
                ]} = data
      end
    end

    test "failing getting the list of authors", %{widget_context: widget_context} do
      with_mock MergeStatDatasource,
        commits_by_author: fn _repo, _params -> @error end do
        data =
          %{"repo" => "https://github.com/livebook-dev/livebook", "limit" => 5}
          |> Handler.get_data(widget_context)

        assert {:error, "could not execute query: near \"asdf\": syntax error"} = data
      end
    end
  end

  def repo_authors() do
    {:ok,
     [
       %{
         "author_email" => "ejankowski@gmail.com",
         "author_name" => "mustela",
         "count" => "296"
       },
       %{
         "author_email" => "guillermo@dinkuminteractive.com",
         "author_name" => "Memo",
         "count" => "47"
       },
       %{
         "author_email" => "ejankowski@gmail.com",
         "author_name" => "Emiliano Jankowski",
         "count" => "11"
       },
       %{
         "author_email" => "49699333+dependabot[bot]@users.noreply.github.com",
         "author_name" => "dependabot[bot]",
         "count" => "8"
       },
       %{
         "author_email" => "pierre@mouraf.org",
         "author_name" => "Pierre-Alexandre Meyer",
         "count" => "1"
       }
     ]}
  end
end
