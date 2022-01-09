defmodule LongformWeb.PageController do
  use LongformWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
