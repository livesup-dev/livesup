defmodule LiveSupWeb.Todo.Components.ManageTodoHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-4/5 flex-wrap">
        <%= link("Home",
          class:
            "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white hidden md:block",
          to: ~p"/"
        ) %>
        <%= link("Projects",
          class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white",
          to: ~p"/projects"
        ) %>
        <%= link(@project.name,
          class: "text-blue-500 after:mx-4 after:content-['>'] dark:after:text-white",
          to: ~p"/projects/#{@project}"
        ) %>
        <span class="text-blue-500 after:mx-4 after:content-['>'] dark:after:text-white">Todos</span>
        <span><%= @todo.title %></span>
      </div>
    </div>
    """
  end
end
