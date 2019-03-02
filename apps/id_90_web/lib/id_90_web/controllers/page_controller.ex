defmodule Id90Web.PageController do
  use Id90Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
