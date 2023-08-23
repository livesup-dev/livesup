defmodule LiveSup.Test.Core.Widgets.MergeStat.ReviewsByAuthor.HandlerTest do
  use LiveSup.DataCase, async: false
  import Mock

  alias LiveSup.Core.Widgets.MergeStat.ReviewsByAuthor.Handler
  alias LiveSup.Core.Datasources.MergeStatDatasource
  alias LiveSup.Schemas.{LinkSchemas, WidgetInstance}
  alias LiveSup.Test.AccountsFixtures
  alias LiveSup.Core.Widgets.WidgetContext

  describe "Managing MergeStat.ReviewsByAuthor handler" do
    @describetag :widget
    @describetag :merge_stat_github_reviews_by_author_widget
    @describetag :merge_stat_github_reviews_by_author_handler

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

      %{user: user}
    end

    test "reviews by author", %{user: user} do
      with_mock MergeStatDatasource,
        reviews_by_author: fn _repo, _params -> reviews_by_author_data() end do
        data =
          %{"repo" => "repo1", "limit" => 5}
          |> Handler.get_data()

        assert {
                 :ok,
                 [
                   %{
                     "author_login" => "mustela",
                     "total_pull_requests_reviewed" => "52",
                     "user" => user
                   },
                   %{
                     "author_login" => "shl311289",
                     "total_pull_requests_reviewed" => "31"
                   },
                   %{
                     "author_login" => "RptorGndalf",
                     "total_pull_requests_reviewed" => "28"
                   },
                   %{
                     "author_login" => "jnscheffr",
                     "total_pull_requests_reviewed" => "23"
                   },
                   %{
                     "author_login" => "JAORMX",
                     "total_pull_requests_reviewed" => "4"
                   }
                 ]
               } = data
      end
    end
  end

  def reviews_by_author_data() do
    {:ok,
     [
       %{
         "author_login" => "mustela",
         "total_pull_requests_reviewed" => "52"
       },
       %{
         "author_login" => "shl311289",
         "total_pull_requests_reviewed" => "31"
       },
       %{
         "author_login" => "RptorGndalf",
         "total_pull_requests_reviewed" => "28"
       },
       %{
         "author_login" => "jnscheffr",
         "total_pull_requests_reviewed" => "23"
       },
       %{
         "author_login" => "JAORMX",
         "total_pull_requests_reviewed" => "4"
       }
     ]}
  end
end
