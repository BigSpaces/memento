defmodule Memento.Content.Snap do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [AshPolicyAuthorizer.Authorizer]

  postgres do
    table "snaps"
    repo Memento.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :description, :string
    attribute :url, :string
  end

  relationships do
    belongs_to :memento, Memento.Content.Memento, allow_nil?: false
  end
end
