defmodule PlanetWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PlanetWeb, :controller
      use PlanetWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: PlanetWeb
      import Plug.Conn
      import PlanetWeb.Router.Helpers
      import PlanetWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/planet_web/templates",
        namespace: PlanetWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PlanetWeb.Router.Helpers
      import PlanetWeb.ErrorHelpers
      import PlanetWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import PlanetWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
