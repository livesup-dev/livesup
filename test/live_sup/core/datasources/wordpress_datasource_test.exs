defmodule LiveSup.Test.Core.Datasources.WordpressDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Helpers.FeatureManager
  alias LiveSup.Core.Datasources.WordpressDatasource

  describe "managing wordpress datasource" do
    @describetag :datasource
    @describetag :wordpress_datasource

    @site_health_parsed_response %{
      "wp-active-theme" => %{
        "health-label" => "Active Theme",
        "health-name" => "wp-active-theme",
        "name" => %{"label" => "Name", "value" => "LIvesup (sup)"},
        "version" => %{"label" => "Version", "value" => "1.0.0"}
      },
      "wp-constants" => %{
        "WP_CACHE" => %{"label" => "WP_CACHE", "value" => "Disabled"},
        "WP_DEBUG" => %{"label" => "WP_DEBUG", "value" => "Disabled"},
        "WP_MAX_MEMORY_LIMIT" => %{"label" => "WP_MAX_MEMORY_LIMIT", "value" => "256M"},
        "WP_MEMORY_LIMIT" => %{"label" => "WP_MEMORY_LIMIT", "value" => "256M"},
        "health-label" => "WordPress Constants",
        "health-name" => "wp-constants"
      },
      "wp-core" => %{
        "blog_public" => %{
          "label" => "Is this site discouraging search engines?",
          "value" => "No"
        },
        "health-label" => "WordPress",
        "health-name" => "wp-core",
        "https_status" => %{"label" => "Is this site using HTTPS?", "value" => "Yes"},
        "version" => %{"label" => "Version", "value" => "5.8.2"}
      },
      "wp-database" => %{
        "database_name" => %{"label" => "Database name", "value" => "db4044012362"},
        "database_prefix" => %{"label" => "Table prefix", "value" => "wp_hfco0vt0up_"},
        "health-label" => "Database",
        "health-name" => "wp-database",
        "server_version" => %{
          "label" => "Server version",
          "value" => "5.6.32-1+deb.sury.org~precise+0.1"
        }
      },
      "wp-filesystem" => %{
        "health-label" => "Filesystem Permissions",
        "health-name" => "wp-filesystem",
        "plugins" => %{"label" => "The plugins directory", "value" => "Writable"},
        "themes" => %{"label" => "The themes directory", "value" => "Writable"},
        "uploads" => %{"label" => "The uploads directory", "value" => "Writable"},
        "wordpress" => %{"label" => "The main WordPress directory", "value" => "Writable"},
        "wp-content" => %{"label" => "The wp-content directory", "value" => "Writable"}
      },
      "wp-media" => %{
        "health-label" => "Media Handling",
        "health-name" => "wp-media",
        "max_effective_size" => %{"label" => "Max effective file size", "value" => "300 MB"},
        "max_file_uploads" => %{"label" => "Max number of files allowed", "value" => "20"},
        "post_max_size" => %{"label" => "Max size of post data allowed", "value" => "300M"},
        "upload_max_filesize" => %{"label" => "Max size of an uploaded file", "value" => "300M"}
      },
      "wp-mu-plugins" => %{
        "health-label" => "Must Use Plugins",
        "health-name" => "wp-mu-plugins",
        "health-total-count" => 1,
        "plugins" => %{
          "dinkum-terminus-mwu" => %{
            "label" => "dinkum-terminus-mwu",
            "value" => "Version 0.0.4 by SiteMavens.com"
          }
        }
      },
      "wp-paths-sizes" => %{
        "database_size" => %{"label" => "Database size", "value" => "Loading&hellip;"},
        "health-label" => "Directories and Sizes",
        "health-name" => "wp-paths-sizes",
        "total_size" => %{"label" => "Total installation size", "value" => "Loading&hellip;"}
      },
      "wp-plugins-active" => %{
        "health-label" => "Active Plugins",
        "health-name" => "wp-plugins-active",
        "health-total-count" => 11,
        "plugins" => %{
          "contactform7" => %{
            "label" => "Contact Form 7",
            "value" => "Version 5.5.2 by Takayuki Miyoshi | Auto-updates disabled"
          },
          "contactformdb" => %{
            "label" => "Contact Form DB",
            "value" => "Version 2.10.32 by Michael Simpson | Auto-updates disabled"
          },
          "defenderpro" => %{
            "label" => "Defender Pro",
            "value" => "Version 2.6.4 by WPMU DEV | Auto-updates disabled"
          },
          "googleanalyticsforwordpressbymonsterinsights" => %{
            "label" => "Google Analytics for WordPress by MonsterInsights",
            "value" => "Version 8.2.0 by MonsterInsights | Auto-updates disabled"
          },
          "livesup" => %{
            "label" => "LiveSup",
            "value" => "Version 1.0.0 by LiveSup | Auto-updates disabled"
          },
          "nativephpsessionsforwordpress" => %{
            "label" => "Native PHP Sessions for WordPress",
            "value" => "Version 1.2.4 by Pantheon | Auto-updates disabled"
          },
          "sliderrevolution" => %{
            "label" => "Slider Revolution",
            "value" => "Version 5.4.1 by ThemePunch | Auto-updates disabled"
          },
          "wordpressimporter" => %{
            "label" => "WordPress Importer",
            "value" => "Version 0.7 by wordpressdotorg | Auto-updates disabled"
          },
          "wpbakeryvisualcomposer" => %{
            "label" => "WPBakery Visual Composer",
            "value" => "Version 5.1.1 by Michael M - WPBakery.com | Auto-updates disabled"
          },
          "wpmudevdashboard" => %{
            "label" => "WPMU DEV Dashboard",
            "value" => "Version 4.11.6 by WPMU DEV | Auto-updates enabled"
          },
          "yoastseo" => %{
            "label" => "Yoast SEO",
            "value" => "Version 17.6 by Team Yoast | Auto-updates disabled"
          }
        }
      },
      "wp-plugins-inactive" => %{
        "health-label" => "Inactive Plugins",
        "health-name" => "wp-plugins-inactive",
        "health-total-count" => 2,
        "plugins" => %{
          "contactform7extensionformailchimp" => %{
            "label" => "Contact Form 7 Extension For Mailchimp",
            "value" => "Version 0.5.52 by Renzo Johnson | Auto-updates disabled"
          },
          "envatowordpresstoolkitdeprecated" => %{
            "label" => "Envato WordPress Toolkit (Deprecated)",
            "value" => "Version 1.8.0 by Envato | Auto-updates disabled"
          }
        }
      },
      "wp-server" => %{
        "health-label" => "Server",
        "health-name" => "wp-server",
        "max_input_variables" => %{"label" => "PHP max input variables", "value" => "4000"},
        "memory_limit" => %{"label" => "PHP memory limit", "value" => "256M"},
        "php_version" => %{
          "label" => "PHP version",
          "value" => "7.4.18 (Supports 64bit values)"
        },
        "pretty_permalinks" => %{
          "label" => "Are pretty permalinks supported?",
          "value" => "Yes"
        },
        "time_limit" => %{"label" => "PHP time limit", "value" => "30"}
      },
      "wp-themes-inactive" => %{
        "health-label" => "Inactive Themes",
        "health-name" => "wp-themes-inactive",
        "health-total-count" => 4,
        "themes" => %{
          "twentyfifteen" => %{
            "label" => "Twenty Fifteen (twentyfifteen)",
            "value" => "Version 3.0 by the WordPress team | Auto-updates disabled"
          },
          "twentynineteen" => %{
            "label" => "Twenty Nineteen (twentynineteen)",
            "value" => "Version 2.1 by the WordPress team | Auto-updates disabled"
          },
          "twentyseventeen" => %{
            "label" => "Twenty Seventeen (twentyseventeen)",
            "value" => "Version 2.8 by the WordPress team | Auto-updates disabled"
          },
          "twentysixteen" => %{
            "label" => "Twenty Sixteen (twentysixteen)",
            "value" => "Version 2.5 by the WordPress team | Auto-updates disabled"
          }
        }
      }
    }

    setup do
      FeatureManager.disable_mock_api()
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "Get site health", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/wp-json/wp-site-live-sup/v1/site-health", fn conn ->
        Plug.Conn.resp(conn, 200, site_health_response())
      end)

      {:ok, data} =
        WordpressDatasource.site_health(%{
          user: "xxx",
          application_password: "xxx",
          url: endpoint_url(bypass.port)
        })

      assert @site_health_parsed_response = data
    end

    test "Get directory sizes", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/wp-json/wp-site-health/v1/directory-sizes", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      {:ok, data} =
        WordpressDatasource.directory_sizes(%{
          user: "xxx",
          application_password: "xxx",
          url: endpoint_url(bypass.port)
        })

      assert [
               {"database_size",
                %{
                  "debug" => "21.78 MB (22839296 bytes)",
                  "raw" => 22_839_296,
                  "size" => "21.78 MB"
                }},
               {"plugins_size",
                %{
                  "debug" => "86.00 MB (90176646 bytes)",
                  "raw" => 90_176_646,
                  "size" => "86.00 MB"
                }},
               {"themes_size",
                %{
                  "debug" => "25.53 MB (26774299 bytes)",
                  "raw" => 26_774_299,
                  "size" => "25.53 MB"
                }},
               {"total_size",
                %{
                  "debug" => "715.89 MB (750669086 bytes)",
                  "raw" => 750_669_086,
                  "size" => "715.89 MB"
                }},
               {"uploads_size",
                %{
                  "debug" => "532.32 MB (558177513 bytes)",
                  "raw" => 558_177_513,
                  "size" => "532.32 MB"
                }},
               {"wordpress_size",
                %{
                  "debug" => "50.26 MB (52701332 bytes)",
                  "raw" => 52_701_332,
                  "size" => "50.26 MB"
                }}
             ] = data
    end

    test "Failing to get directory sizes", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/wp-json/wp-site-health/v1/directory-sizes", fn conn ->
        Plug.Conn.resp(conn, 401, error_response())
      end)

      data =
        WordpressDatasource.directory_sizes(%{
          user: "xxx",
          application_password: "xxx",
          url: endpoint_url(bypass.port)
        })

      assert {:error, "401: Sorry, you are not allowed to do that."} = data
    end

    def site_health_response() do
      """
      {
        "wp-core": {
            "health-name": "wp-core",
            "health-label": "WordPress",
            "version": {
                "label": "Version",
                "value": "5.8.2"
            },
            "https_status": {
                "label": "Is this site using HTTPS?",
                "value": "Yes"
            },
            "blog_public": {
                "label": "Is this site discouraging search engines?",
                "value": "No"
            }
        },
        "wp-paths-sizes": {
            "health-name": "wp-paths-sizes",
            "health-label": "Directories and Sizes",
            "database_size": {
                "label": "Database size",
                "value": "Loading&hellip;"
            },
            "total_size": {
                "label": "Total installation size",
                "value": "Loading&hellip;"
            }
        },
        "wp-active-theme": {
            "health-name": "wp-active-theme",
            "health-label": "Active Theme",
            "name": {
                "label": "Name",
                "value": "LIvesup (sup)"
            },
            "version": {
                "label": "Version",
                "value": "1.0.0"
            }
        },
        "wp-themes-inactive": {
            "health-name": "wp-themes-inactive",
            "health-label": "Inactive Themes",
            "health-total-count": 4,
            "themes": {
                "twentyfifteen": {
                    "label": "Twenty Fifteen (twentyfifteen)",
                    "value": "Version 3.0 by the WordPress team | Auto-updates disabled"
                },
                "twentynineteen": {
                    "label": "Twenty Nineteen (twentynineteen)",
                    "value": "Version 2.1 by the WordPress team | Auto-updates disabled"
                },
                "twentyseventeen": {
                    "label": "Twenty Seventeen (twentyseventeen)",
                    "value": "Version 2.8 by the WordPress team | Auto-updates disabled"
                },
                "twentysixteen": {
                    "label": "Twenty Sixteen (twentysixteen)",
                    "value": "Version 2.5 by the WordPress team | Auto-updates disabled"
                }
            }
        },
        "wp-mu-plugins": {
            "health-name": "wp-mu-plugins",
            "health-label": "Must Use Plugins",
            "health-total-count": 1,
            "plugins": {
                "dinkum-terminus-mwu": {
                    "label": "dinkum-terminus-mwu",
                    "value": "Version 0.0.4 by SiteMavens.com"
                }
            }
        },
        "wp-plugins-active": {
            "health-name": "wp-plugins-active",
            "health-label": "Active Plugins",
            "health-total-count": 11,
            "plugins": {
                "contactform7": {
                    "label": "Contact Form 7",
                    "value": "Version 5.5.2 by Takayuki Miyoshi | Auto-updates disabled"
                },
                "contactformdb": {
                    "label": "Contact Form DB",
                    "value": "Version 2.10.32 by Michael Simpson | Auto-updates disabled"
                },
                "defenderpro": {
                    "label": "Defender Pro",
                    "value": "Version 2.6.4 by WPMU DEV | Auto-updates disabled"
                },
                "googleanalyticsforwordpressbymonsterinsights": {
                    "label": "Google Analytics for WordPress by MonsterInsights",
                    "value": "Version 8.2.0 by MonsterInsights | Auto-updates disabled"
                },
                "livesup": {
                    "label": "LiveSup",
                    "value": "Version 1.0.0 by LiveSup | Auto-updates disabled"
                },
                "nativephpsessionsforwordpress": {
                    "label": "Native PHP Sessions for WordPress",
                    "value": "Version 1.2.4 by Pantheon | Auto-updates disabled"
                },
                "sliderrevolution": {
                    "label": "Slider Revolution",
                    "value": "Version 5.4.1 by ThemePunch | Auto-updates disabled"
                },
                "wordpressimporter": {
                    "label": "WordPress Importer",
                    "value": "Version 0.7 by wordpressdotorg | Auto-updates disabled"
                },
                "wpbakeryvisualcomposer": {
                    "label": "WPBakery Visual Composer",
                    "value": "Version 5.1.1 by Michael M - WPBakery.com | Auto-updates disabled"
                },
                "wpmudevdashboard": {
                    "label": "WPMU DEV Dashboard",
                    "value": "Version 4.11.6 by WPMU DEV | Auto-updates enabled"
                },
                "yoastseo": {
                    "label": "Yoast SEO",
                    "value": "Version 17.6 by Team Yoast | Auto-updates disabled"
                }
            }
        },
        "wp-plugins-inactive": {
            "health-name": "wp-plugins-inactive",
            "health-label": "Inactive Plugins",
            "health-total-count": 2,
            "plugins": {
                "contactform7extensionformailchimp": {
                    "label": "Contact Form 7 Extension For Mailchimp",
                    "value": "Version 0.5.52 by Renzo Johnson | Auto-updates disabled"
                },
                "envatowordpresstoolkitdeprecated": {
                    "label": "Envato WordPress Toolkit (Deprecated)",
                    "value": "Version 1.8.0 by Envato | Auto-updates disabled"
                }
            }
        },
        "wp-media": {
            "health-name": "wp-media",
            "health-label": "Media Handling",
            "post_max_size": {
                "label": "Max size of post data allowed",
                "value": "300M"
            },
            "upload_max_filesize": {
                "label": "Max size of an uploaded file",
                "value": "300M"
            },
            "max_effective_size": {
                "label": "Max effective file size",
                "value": "300 MB"
            },
            "max_file_uploads": {
                "label": "Max number of files allowed",
                "value": "20"
            }
        },
        "wp-server": {
            "health-name": "wp-server",
            "health-label": "Server",
            "php_version": {
                "label": "PHP version",
                "value": "7.4.18 (Supports 64bit values)"
            },
            "max_input_variables": {
                "label": "PHP max input variables",
                "value": "4000"
            },
            "time_limit": {
                "label": "PHP time limit",
                "value": "30"
            },
            "memory_limit": {
                "label": "PHP memory limit",
                "value": "256M"
            },
            "pretty_permalinks": {
                "label": "Are pretty permalinks supported?",
                "value": "Yes"
            }
        },
        "wp-database": {
            "health-name": "wp-database",
            "health-label": "Database",
            "server_version": {
                "label": "Server version",
                "value": "5.6.32-1+deb.sury.org~precise+0.1"
            },
            "database_name": {
                "label": "Database name",
                "value": "db4044012362"
            },
            "database_prefix": {
                "label": "Table prefix",
                "value": "wp_hfco0vt0up_"
            }
        },
        "wp-constants": {
            "health-name": "wp-constants",
            "health-label": "WordPress Constants",
            "WP_MEMORY_LIMIT": {
                "label": "WP_MEMORY_LIMIT",
                "value": "256M"
            },
            "WP_MAX_MEMORY_LIMIT": {
                "label": "WP_MAX_MEMORY_LIMIT",
                "value": "256M"
            },
            "WP_DEBUG": {
                "label": "WP_DEBUG",
                "value": "Disabled"
            },
            "WP_CACHE": {
                "label": "WP_CACHE",
                "value": "Disabled"
            }
        },
        "wp-filesystem": {
            "health-name": "wp-filesystem",
            "health-label": "Filesystem Permissions",
            "wordpress": {
                "label": "The main WordPress directory",
                "value": "Writable"
            },
            "wp-content": {
                "label": "The wp-content directory",
                "value": "Writable"
            },
            "uploads": {
                "label": "The uploads directory",
                "value": "Writable"
            },
            "plugins": {
                "label": "The plugins directory",
                "value": "Writable"
            },
            "themes": {
                "label": "The themes directory",
                "value": "Writable"
            }
        }
      }
      """
    end

    def response() do
      """
      {
        "raw": 0,
        "wordpress_size": {
            "size": "50.26 MB",
            "debug": "50.26 MB (52701332 bytes)",
            "raw": 52701332
        },
        "themes_size": {
            "size": "25.53 MB",
            "debug": "25.53 MB (26774299 bytes)",
            "raw": 26774299
        },
        "plugins_size": {
            "size": "86.00 MB",
            "debug": "86.00 MB (90176646 bytes)",
            "raw": 90176646
        },
        "uploads_size": {
            "size": "532.32 MB",
            "debug": "532.32 MB (558177513 bytes)",
            "raw": 558177513
        },
        "database_size": {
            "size": "21.78 MB",
            "debug": "21.78 MB (22839296 bytes)",
            "raw": 22839296
        },
        "total_size": {
            "size": "715.89 MB",
            "debug": "715.89 MB (750669086 bytes)",
            "raw": 750669086
        }
      }
      """
    end

    def error_response() do
      """
      {
          "code": "rest_forbidden",
          "message": "Sorry, you are not allowed to do that.",
          "data": {
              "status": 401
          }
      }
      """
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
