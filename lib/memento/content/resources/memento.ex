defmodule Memento.Content.Memento do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [AshPolicyAuthorizer.Authorizer]

  postgres do
    table "mementos"
    repo Memento.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :description, :string
  end

  relationships do
    belongs_to :user, Memento.Accounts.User do
      api Memento.Accounts
    end

    has_many :snap, Memento.Content.Snap
  end
end
