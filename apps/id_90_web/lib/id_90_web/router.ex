defmodule Id90Web.Router do
  use Id90Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Id90Web do
    pipe_through :browser

    # get "/", PageController, :index

    resources "/", UserController do
      resources "/flights", FlightController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Id90Web do
  #   pipe_through :api
  # end
end
