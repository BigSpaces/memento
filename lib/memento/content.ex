defmodule Memento.Content do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    registry Memento.Content.Registry
  end
end
