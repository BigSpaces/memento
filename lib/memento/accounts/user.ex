defmodule Memento.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    api Memento.Accounts

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true
      end
    end

    tokens do
      enabled? true
      token_resource Memento.Accounts.Token

      signing_secret fn _, _ ->
        Application.fetch_env(:memento, :token_signing_secret) |> IO.inspect(label: "Token Signing Secret")
      end
    end
  end

  postgres do
    table "users"
    repo Memento.Repo
  end

  identities do
    identity :unique_email, [:email]
  end

  # relationships do
  #   has_many :memento, Memento.Content.Memento do
  #     api Memento.Content
  #   end

 # end
  # If using policies, add the folowing bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
