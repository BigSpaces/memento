defmodule Memento.Accounts do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    resource Memento.Accounts.User
    resource Memento.Accounts.Token
  end
end
