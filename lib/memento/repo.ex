defmodule Memento.Repo do
  use AshPostgres.Repo,
    otp_app: :memento

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
