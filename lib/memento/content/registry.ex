defmodule Memento.Content.Registry do
  use Ash.Registry

  entries do
    entry Memento.Content.Memento
    entry Memento.Content.Snap
  end
end
