defmodule LiveSupWeb.Components.Global.Head do
  use LiveSupWeb, :component

  attr :title, :string, required: true

  def head(assigns) do
    ~H"""
    <head>
    <!-- Meta tags  -->
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta
        name="viewport"
        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
      />

      <meta name="csrf-token" content={csrf_token_value()}>
      <%= live_title_tag assigns[:page_title] || "LiveSup" %>

      <link rel="icon" type="image/png" href="images/favicon.png" />

      <link phx-track-static rel="stylesheet" href={Routes.static_path(LiveSupWeb.Endpoint, "/css/app.css")}/>
      <script defer phx-track-static type="text/javascript" src={Routes.static_path(LiveSupWeb.Endpoint, "/js/app.js")}></script>

      <!-- Fonts -->
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
        rel="stylesheet"
      />
    </head>
    """
  end
end
