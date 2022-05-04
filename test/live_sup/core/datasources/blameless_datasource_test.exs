defmodule LiveSup.Test.Core.Datasources.BlamelessDatasourceTest do
  use LiveSup.DataCase, async: false

  import Mock

  alias LiveSup.Core.Datasources.BlamelessDatasource
  alias LiveSup.Core.Datasources.HttpDatasource

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "Blamelesss datasource" do
    @describetag :datasource
    @describetag :blameless_datasource
    test "Get incidents", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/api/v1/incidents", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      with_mock HttpDatasource, [:passthrough],
        post: fn _params -> {:ok, %{"access_token" => "valid_token"}} end do
        data =
          BlamelessDatasource.get_incidents(
            credentials: %{
              "audience" => "xxxx",
              "client_id" => "xxxx",
              "client_secret" => "xxxx",
              "endpoint" => endpoint_url(bypass.port)
            }
          )

        assert {
                 :ok,
                 [
                   %{
                     commander: %{
                       avatar_url: "https://avatars.slack-edge.com/2018-10-15/xxxxxxx.png",
                       email: "some@email.com",
                       full_name: "Tim Brown",
                       title: "Awesome Engineer"
                     },
                     communication_lead: nil,
                     created_at: ~U[2021-11-12 22:15:07.217Z],
                     created_at_ago: _,
                     description: "Phoenix down",
                     severity: "SEV1: Customers Impacted",
                     slack: %{
                       channel: "_incident-958",
                       url: "https://livesup.slack.com/archives/C02M0HEGELE"
                     },
                     status: "MONITORING",
                     type: "Network",
                     updated_at: ~U[2021-11-12 23:35:45.675Z],
                     url: "https://livesup.blameless.io/incidents/958/events"
                   },
                   %{
                     commander: nil,
                     communication_lead: %{
                       avatar_url: "https://avatars.slack-edge.com/2021-05-24/xxxxxxx.jpg",
                       email: "john@livesup.com",
                       full_name: "John Pablo",
                       title: "Sr. Customer Success Engineer"
                     },
                     created_at: ~U[2021-11-08 08:34:30.495Z],
                     created_at_ago: _,
                     description: "Provisioning queues increasing",
                     severity: "SEV1: Customers Impacted",
                     slack: %{
                       channel: "_incident-954",
                       url: "https://livesup.slack.com/archives/C02M6N79G00"
                     },
                     status: "INVESTIGATING",
                     type: "general",
                     updated_at: ~U[2021-11-08 08:59:06.830Z],
                     url: "https://livesup.blameless.io/incidents/954/events"
                   },
                   %{
                     commander: nil,
                     communication_lead: nil,
                     created_at: ~U[2021-11-04 09:11:26.641Z],
                     created_at_ago: _,
                     description: "Deprov Queues increasing",
                     severity: "SEV2: Urgent Problem",
                     slack: %{
                       channel: "_incident-952",
                       url: "https://livesup.slack.com/archives/C02L5JLAB9Q"
                     },
                     status: "INVESTIGATING",
                     type: "general",
                     updated_at: ~U[2021-11-04 09:12:53.268Z],
                     url: "https://livesup.blameless.io/incidents/952/events"
                   }
                 ]
               } = data
      end
    end

    @tag :datasource_current_incidents
    test "Get current incidents", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/api/v1/incidents", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      with_mock HttpDatasource, [:passthrough],
        post: fn _params -> {:ok, %{"access_token" => "valid_token"}} end do
        data =
          BlamelessDatasource.get_current_incidents(
            credentials: %{
              "audience" => "xxxx",
              "client_id" => "xxxx",
              "client_secret" => "xxxx",
              "endpoint" => endpoint_url(bypass.port)
            }
          )

        assert {
                 :ok,
                 [
                   %{
                     commander: %{
                       avatar_url: "https://avatars.slack-edge.com/2018-10-15/xxxxxxx.png",
                       email: "some@email.com",
                       full_name: "Tim Brown",
                       title: "Awesome Engineer"
                     },
                     communication_lead: nil,
                     created_at: ~U[2021-11-12 22:15:07.217Z],
                     created_at_ago: _,
                     description: "Phoenix down",
                     severity: "SEV1: Customers Impacted",
                     slack: %{
                       channel: "_incident-958",
                       url: "https://livesup.slack.com/archives/C02M0HEGELE"
                     },
                     status: "MONITORING",
                     type: "Network",
                     updated_at: ~U[2021-11-12 23:35:45.675Z],
                     url: "https://livesup.blameless.io/incidents/958/events"
                   },
                   %{
                     commander: nil,
                     communication_lead: %{
                       avatar_url: "https://avatars.slack-edge.com/2021-05-24/xxxxxxx.jpg",
                       email: "john@livesup.com",
                       full_name: "John Pablo",
                       title: "Sr. Customer Success Engineer"
                     },
                     created_at: ~U[2021-11-08 08:34:30.495Z],
                     created_at_ago: _,
                     description: "Provisioning queues increasing",
                     severity: "SEV1: Customers Impacted",
                     slack: %{
                       channel: "_incident-954",
                       url: "https://livesup.slack.com/archives/C02M6N79G00"
                     },
                     status: "INVESTIGATING",
                     type: "general",
                     updated_at: ~U[2021-11-08 08:59:06.830Z],
                     url: "https://livesup.blameless.io/incidents/954/events"
                   },
                   %{
                     commander: nil,
                     communication_lead: nil,
                     created_at: ~U[2021-11-04 09:11:26.641Z],
                     created_at_ago: _,
                     description: "Deprov Queues increasing",
                     severity: "SEV2: Urgent Problem",
                     slack: %{
                       channel: "_incident-952",
                       url: "https://livesup.slack.com/archives/C02L5JLAB9Q"
                     },
                     status: "INVESTIGATING",
                     type: "general",
                     updated_at: ~U[2021-11-04 09:12:53.268Z],
                     url: "https://livesup.blameless.io/incidents/952/events"
                   }
                 ]
               } = data
      end
    end

    test "Fail to get the list of incidents" do
      with_mock HttpDatasource,
        post: fn _params ->
          {:error,
           %{
             "error" => "access_denied",
             "error_description" => "Unauthorized"
           }}
        end do
        data =
          BlamelessDatasource.get_incidents(
            credentials: %{
              "audience" => "xxxx",
              "client_id" => "xxxx",
              "client_secret" => "xxxx"
            }
          )

        assert {:error, "access_denied: Unauthorized"} = data
      end
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"

  defp response() do
    """
    {
      "ok": true,
      "incidents": [
          {
              "_id": 958,
              "is_deleted": false,
              "created": {
                  "$date": 1636755307217
              },
              "updated": {
                  "$date": 1636760145675
              },
              "is_shadow": false,
              "creator": "UDA0E283B",
              "blameless_creator": "140",
              "roles": {
                  "commander": "UDA0E283B"
              },
              "blameless_roles": {
                  "commander": "140"
              },
              "description": "Phoenix down",
              "status": "MONITORING",
              "severity": "SEV1: Customers Impacted",
              "mute": false,
              "is_postmortem_required": true,
              "type": "Network",
              "duplicate_of": "",
              "start_of_customer_impact": {
                  "$date": 1636755307217
              },
              "start_of_incident_impact": {
                  "$date": 1636755307217
              },
              "time_to_identification": 0,
              "time_to_take_action": 0,
              "time_to_resolution": 0,
              "duration_of_customer_impact": 0,
              "duration_of_incident_impact": 0,
              "team": [
                  {
                      "_id": "UDA0E283B",
                      "profile": {
                          "title": "Awesome Engineer",
                          "phone": "99999999",
                          "skype": "awesome@livesup.com",
                          "real_name": "Tim Brown",
                          "real_name_normalized": "Tim Brown",
                          "display_name": "osbrown",
                          "display_name_normalized": "osbrown",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "1166d8d74359",
                          "image_original": "https://avatars.slack-edge.com/2018-10-15/456767371780_original.png",
                          "is_custom_image": true,
                          "email": "some@email.com",
                          "first_name": "Tim",
                          "last_name": "Osburn",
                          "image_24": "https://avatars.slack-edge.com/2018-10-15/456767371780_24.png",
                          "image_32": "https://avatars.slack-edge.com/2018-10-15/xxxxxxx.png",
                          "image_48": "https://avatars.slack-edge.com/2018-10-15/456767371780_48.png",
                          "image_72": "https://avatars.slack-edge.com/2018-10-15/456767371780_72.png",
                          "image_192": "https://avatars.slack-edge.com/2018-10-15/456767371780_192.png",
                          "image_512": "https://avatars.slack-edge.com/2018-10-15/456767371780_512.png",
                          "image_1024": "https://avatars.slack-edge.com/2018-10-15/456767371780_1024.png",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "osbrown"
                      },
                      "roles": [
                          "Creator",
                          "Commander"
                      ]
                  },
                  {
                      "_id": "U010X62TL80",
                      "profile": {
                          "title": "Director, LiveSup Platform Engineering",
                          "phone": "999999999",
                          "skype": "matandim@livesup.com",
                          "real_name": "Matt Andim",
                          "real_name_normalized": "Matt Andim",
                          "display_name": "mandim",
                          "display_name_normalized": "mandim",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "8ac5015f7de9",
                          "image_original": "https://avatars.slack-edge.com/2020-03-27/1019088488194_original.jpg",
                          "is_custom_image": true,
                          "email": "mandim@livesup.com",
                          "first_name": "Matt",
                          "last_name": "Anderson",
                          "image_24": "https://avatars.slack-edge.com/2020-03-27/1019088488194_24.jpg",
                          "image_32": "https://avatars.slack-edge.com/2020-03-27/1019088488194.jpg",
                          "image_48": "https://avatars.slack-edge.com/2020-03-27/1019088488194_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2020-03-27/1019088488194_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2020-03-27/1019088488194_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2020-03-27/1019088488194_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2020-03-27/1019088488194_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "mandim"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "U1D00EUPP",
                      "profile": {
                          "title": "Staff Software Engineer",
                          "phone": "9999999999",
                          "skype": "tstark@livesup.com",
                          "real_name": "Tony Stark",
                          "real_name_normalized": "Tony Stark",
                          "display_name": "tony",
                          "display_name_normalized": "tony",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "0c4cbf76d57d",
                          "image_original": "https://avatars.slack-edge.com/2018-09-13/433936726944_original.jpg",
                          "is_custom_image": true,
                          "email": "tony@livesup.com",
                          "first_name": "Tony",
                          "last_name": "Perez",
                          "image_24": "https://avatars.slack-edge.com/2018-09-13/433936726944.jpg",
                          "image_32": "https://avatars.slack-edge.com/2018-09-13/433936726944_32.jpg",
                          "image_48": "https://avatars.slack-edge.com/2018-09-13/433936726944_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2018-09-13/433936726944_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2018-09-13/433936726944_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2018-09-13/433936726944_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2018-09-13/433936726944_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "tony"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "U9A5ZB23A",
                      "profile": {
                          "title": "Senior Manager, Network Service Engineering",
                          "phone": "973-219-9916",
                          "skype": "jdoe@livesup.com",
                          "real_name": "Joe Doe",
                          "real_name_normalized": "Joe Doe",
                          "display_name": "JoeD",
                          "display_name_normalized": "JoeD",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "638ccdc3003d",
                          "image_original": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_original.jpg",
                          "is_custom_image": true,
                          "email": "joed@livesup.com",
                          "first_name": "Joe",
                          "last_name": "Doe",
                          "image_24": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_24.jpg",
                          "image_32": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_32.jpg",
                          "image_48": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2018-02-22/318589051120ee_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "joed"
                      },
                      "roles": [
                          "Participant"
                      ]
                  }
              ],
              "blameless_team": [
                  "140",
                  "334",
                  "111"
              ],
              "blamo_provider_name": "slack",
              "slack_channel": {
                  "id": "C02M0HEGELE",
                  "name": "_incident-958",
                  "url": "https://livesup.slack.com/archives/C02M0HEGELE",
                  "is_private": false,
                  "announcements": [
                      {
                          "channel_id": "CCYMKHE1G",
                          "msg_ts": "1636755308.054600"
                      },
                      {
                          "channel_id": "C02M0HEGELE",
                          "msg_ts": "1636755309.000600"
                      },
                      {
                          "channel_id": "CHTSD599V",
                          "msg_ts": "1636755326.029100"
                      }
                  ],
                  "task_lists": [
                      {
                          "channel_id": "C02M0HEGELE",
                          "msg_ts": "1636755322.005400"
                      }
                  ]
              },
              "incident_start_slack_metadata": {
                  "channel_id": "CCYMKHE1G",
                  "message_id": "1636755306.054500",
                  "is_private": false,
                  "message_link": "https://livesup.slack.com/archives/CCYMKHE1G/p1636755306054500",
                  "thread_root_link": null
              },
              "name": "958",
              "postmortem_state": null
          },
          {
              "_id": 954,
              "is_deleted": false,
              "created": {
                  "$date": 1636360470495
              },
              "updated": {
                  "$date": 1636361946830
              },
              "is_shadow": false,
              "creator": "U021S3H0XK3",
              "blameless_creator": "1457",
              "roles": {
                  "commander": "UGZNN341W",
                  "communication_lead": "U021S3H0XK3"
              },
              "blameless_roles": {
                  "commander": "67",
                  "communication_lead": "1457"
              },
              "description": "Provisioning queues increasing",
              "status": "INVESTIGATING",
              "severity": "SEV1: Customers Impacted",
              "mute": false,
              "is_postmortem_required": true,
              "type": "general",
              "duplicate_of": "",
              "start_of_customer_impact": {
                  "$date": 1636360470495
              },
              "start_of_incident_impact": {
                  "$date": 1636360470495
              },
              "time_to_identification": 0,
              "time_to_take_action": 0,
              "time_to_resolution": 0,
              "duration_of_customer_impact": 0,
              "duration_of_incident_impact": 0,
              "team": [
                  {
                      "_id": "U021S3H0XK3",
                      "profile": {
                          "title": "Sr. Customer Success Engineer",
                          "phone": "+99 999 999 9999",
                          "skype": "",
                          "real_name": "John Pablo",
                          "real_name_normalized": "John Pablo",
                          "display_name": "John",
                          "display_name_normalized": "John",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "e2fd3d7da869",
                          "image_original": "https://avatars.slack-edge.com/2021-05-24/2092905852181_original.jpg",
                          "is_custom_image": true,
                          "email": "john@livesup.com",
                          "first_name": "John",
                          "last_name": "Pablo",
                          "image_24": "https://avatars.slack-edge.com/2021-05-24/2092905852181_24.jpg",
                          "image_32": "https://avatars.slack-edge.com/2021-05-24/xxxxxxx.jpg",
                          "image_48": "https://avatars.slack-edge.com/2021-05-24/2092905852181_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2021-05-24/2092905852181_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2021-05-24/2092905852181_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2021-05-24/2092905852181_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2021-05-24/2092905852181_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "john"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "U010X62TL80",
                      "profile": {
                          "title": "Director, LiveSup Platform Engineering",
                          "phone": "999999999",
                          "skype": "matandim@livesup.com",
                          "real_name": "Matt Andim",
                          "real_name_normalized": "Matt Andim",
                          "display_name": "mandim",
                          "display_name_normalized": "mandim",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "8ac5015f7de9",
                          "image_original": "https://avatars.slack-edge.com/2020-03-27/1019088488194_original.jpg",
                          "is_custom_image": true,
                          "email": "mandim@livesup.com",
                          "first_name": "Matt",
                          "last_name": "Anderson",
                          "image_24": "https://avatars.slack-edge.com/2020-03-27/1019088488194_24.jpg",
                          "image_32": "https://avatars.slack-edge.com/2020-03-27/1019088488194.jpg",
                          "image_48": "https://avatars.slack-edge.com/2020-03-27/1019088488194_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2020-03-27/1019088488194_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2020-03-27/1019088488194_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2020-03-27/1019088488194_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2020-03-27/1019088488194_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "mandim"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "UL3T24T7F",
                      "profile": {
                          "title": "Sales Eng",
                          "phone": "999999999",
                          "skype": "petersmith@livesup.com",
                          "real_name": "Peter Smith",
                          "real_name_normalized": "Peter Smith",
                          "display_name": "Peter",
                          "display_name_normalized": "Peter",
                          "fields": {},
                          "status_text": "In a meeting • Outlook Calendar",
                          "status_emoji": ":spiral_calendar_pad:",
                          "status_emoji_display_info": [],
                          "status_expiration": 1636920000,
                          "avatar_hash": "gea77bcadf35",
                          "email": "peter@livesup.com",
                          "first_name": "Dave",
                          "last_name": "Smith",
                          "image_24": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=24&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-24.png",
                          "image_32": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=32&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-32.png",
                          "image_48": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=48&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-48.png",
                          "image_72": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-72.png",
                          "image_192": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=192&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-192.png",
                          "image_512": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-512.png",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "U1D00EUPP",
                      "profile": {
                          "title": "Staff Software Engineer",
                          "phone": "9999999999",
                          "skype": "tstark@livesup.com",
                          "real_name": "Tony Stark",
                          "real_name_normalized": "Tony Stark",
                          "display_name": "tony",
                          "display_name_normalized": "tony",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "0c4cbf76d57d",
                          "image_original": "https://avatars.slack-edge.com/2018-09-13/433936726944_original.jpg",
                          "is_custom_image": true,
                          "email": "tony@livesup.com",
                          "first_name": "Tony",
                          "last_name": "Perez",
                          "image_24": "https://avatars.slack-edge.com/2018-09-13/433936726944.jpg",
                          "image_32": "https://avatars.slack-edge.com/2018-09-13/433936726944_32.jpg",
                          "image_48": "https://avatars.slack-edge.com/2018-09-13/433936726944_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2018-09-13/433936726944_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2018-09-13/433936726944_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2018-09-13/433936726944_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2018-09-13/433936726944_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "tony"
                      },
                      "roles": [
                          "Participant"
                      ]
                  }
              ],
              "blameless_team": [
                  "1457",
                  "334",
                  "54",
                  "22"
              ],
              "blamo_provider_name": "slack",
              "slack_channel": {
                  "id": "C02M6N79G00",
                  "name": "_incident-954",
                  "url": "https://livesup.slack.com/archives/C02M6N79G00",
                  "is_private": false,
                  "announcements": [
                      {
                          "channel_id": "C02M6N79G00",
                          "msg_ts": "1636360471.000600"
                      },
                      {
                          "channel_id": "CHTSD599V",
                          "msg_ts": "1636360489.022700"
                      },
                      {
                          "channel_id": "C02BXTAT2",
                          "msg_ts": "1636360489.202400"
                      }
                  ],
                  "task_lists": [
                      {
                          "channel_id": "C02M6N79G00",
                          "msg_ts": "1636360483.005200"
                      }
                  ]
              },
              "incident_start_slack_metadata": {
                  "channel_id": "CHTSD599V",
                  "message_id": "1636360469.022400",
                  "is_private": false,
                  "message_link": "https://livesup.slack.com/archives/CHTSD599V/p1636360469022400",
                  "thread_root_link": null
              },
              "name": "954",
              "postmortem_state": null
          },
          {
              "_id": 952,
              "is_deleted": false,
              "created": {
                  "$date": 1636017086641
              },
              "updated": {
                  "$date": 1636017173268
              },
              "is_shadow": false,
              "creator": "U021S3H0XK3",
              "blameless_creator": "1457",
              "roles": {
                  "commander": "ULDR95S3E"
              },
              "blameless_roles": {
                  "commander": "167"
              },
              "description": "Deprov Queues increasing",
              "status": "INVESTIGATING",
              "severity": "SEV2: Urgent Problem",
              "mute": false,
              "is_postmortem_required": true,
              "type": "general",
              "duplicate_of": "",
              "start_of_customer_impact": {
                  "$date": 1636017086641
              },
              "start_of_incident_impact": {
                  "$date": 1636017086641
              },
              "time_to_identification": 0,
              "time_to_take_action": 0,
              "time_to_resolution": 0,
              "duration_of_customer_impact": 0,
              "duration_of_incident_impact": 0,
              "team": [
                  {
                      "_id": "U021S3H0XK3",
                      "profile": {
                          "title": "Sr. Customer Success Engineer",
                          "phone": "+99 999 999 9999",
                          "skype": "",
                          "real_name": "John Pablo",
                          "real_name_normalized": "John Pablo",
                          "display_name": "John",
                          "display_name_normalized": "John",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "e2fd3d7da869",
                          "image_original": "https://avatars.slack-edge.com/2021-05-24/2092905852181_original.jpg",
                          "is_custom_image": true,
                          "email": "john@livesup.com",
                          "first_name": "John",
                          "last_name": "Pablo",
                          "image_24": "https://avatars.slack-edge.com/2021-05-24/2092905852181_24.jpg",
                          "image_32": "https://avatars.slack-edge.com/2021-05-24/xxxxxxx.jpg",
                          "image_48": "https://avatars.slack-edge.com/2021-05-24/2092905852181_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2021-05-24/2092905852181_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2021-05-24/2092905852181_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2021-05-24/2092905852181_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2021-05-24/2092905852181_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "john"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "UL3T24T7F",
                      "profile": {
                          "title": "Sales Eng",
                          "phone": "999999999",
                          "skype": "petersmith@livesup.com",
                          "real_name": "Peter Smith",
                          "real_name_normalized": "Peter Smith",
                          "display_name": "Peter",
                          "display_name_normalized": "Peter",
                          "fields": {},
                          "status_text": "In a meeting • Outlook Calendar",
                          "status_emoji": ":spiral_calendar_pad:",
                          "status_emoji_display_info": [],
                          "status_expiration": 1636920000,
                          "avatar_hash": "gea77bcadf35",
                          "email": "peter@livesup.com",
                          "first_name": "Dave",
                          "last_name": "Smith",
                          "image_24": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=24&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-24.png",
                          "image_32": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=32&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-32.png",
                          "image_48": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=48&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-48.png",
                          "image_72": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=72&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-72.png",
                          "image_192": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=192&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-192.png",
                          "image_512": "https://secure.gravatar.com/avatar/9999999999999999999999.jpg?s=512&d=https%3A%2F%2Fa.slack-edge.com%2Fdf10d%2Fimg%2Favatars%2Fava_0011-512.png",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78"
                      },
                      "roles": [
                          "Participant"
                      ]
                  },
                  {
                      "_id": "U1D00EUPP",
                      "profile": {
                          "title": "Staff Software Engineer",
                          "phone": "9999999999",
                          "skype": "tstark@livesup.com",
                          "real_name": "Tony Stark",
                          "real_name_normalized": "Tony Stark",
                          "display_name": "tony",
                          "display_name_normalized": "tony",
                          "fields": null,
                          "status_text": "",
                          "status_emoji": "",
                          "status_emoji_display_info": [],
                          "status_expiration": 0,
                          "avatar_hash": "0c4cbf76d57d",
                          "image_original": "https://avatars.slack-edge.com/2018-09-13/433936726944_original.jpg",
                          "is_custom_image": true,
                          "email": "tony@livesup.com",
                          "first_name": "Tony",
                          "last_name": "Perez",
                          "image_24": "https://avatars.slack-edge.com/2018-09-13/433936726944.jpg",
                          "image_32": "https://avatars.slack-edge.com/2018-09-13/433936726944_32.jpg",
                          "image_48": "https://avatars.slack-edge.com/2018-09-13/433936726944_48.jpg",
                          "image_72": "https://avatars.slack-edge.com/2018-09-13/433936726944_72.jpg",
                          "image_192": "https://avatars.slack-edge.com/2018-09-13/433936726944_192.jpg",
                          "image_512": "https://avatars.slack-edge.com/2018-09-13/433936726944_512.jpg",
                          "image_1024": "https://avatars.slack-edge.com/2018-09-13/433936726944_1024.jpg",
                          "status_text_canonical": "",
                          "team": "T02BWUJ78",
                          "name": "tony"
                      },
                      "roles": [
                          "Participant"
                      ]
                  }
              ],
              "blameless_team": [
                  "1457",
                  "54",
                  "111"
              ],
              "blamo_provider_name": "slack",
              "slack_channel": {
                  "id": "C02L5JLAB9Q",
                  "name": "_incident-952",
                  "url": "https://livesup.slack.com/archives/C02L5JLAB9Q",
                  "is_private": false,
                  "announcements": [
                      {
                          "channel_id": "C02L5JLAB9Q",
                          "msg_ts": "1636017088.000600"
                      },
                      {
                          "channel_id": "CHTSD599V",
                          "msg_ts": "1636017129.020100"
                      },
                      {
                          "channel_id": "C02BXTAT2",
                          "msg_ts": "1636017130.170400"
                      }
                  ],
                  "task_lists": [
                      {
                          "channel_id": "C02L5JLAB9Q",
                          "msg_ts": "1636017128.003400"
                      }
                  ]
              },
              "incident_start_slack_metadata": {
                  "channel_id": "CHTSD599V",
                  "message_id": "1636017086.019800",
                  "is_private": false,
                  "message_link": "https://livesup.slack.com/archives/CHTSD599V/p1636017086019800",
                  "thread_root_link": null
              },
              "name": "952",
              "postmortem_state": null
          }
      ],
      "pagination": {
          "limit": 10,
          "offset": 0,
          "count": 2
      }
    }
    """
  end
end
