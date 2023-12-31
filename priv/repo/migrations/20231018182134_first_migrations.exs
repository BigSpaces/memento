defmodule Memento.Repo.Migrations.FirstMigrations do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :text, null: false
    end

    create unique_index(:users, [:email], name: "users_unique_email_index")

    create table(:tokens, primary_key: false) do
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :created_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :extra_data, :map
      add :purpose, :text, null: false
      add :expires_at, :utc_datetime, null: false
      add :subject, :text, null: false
      add :jti, :text, null: false, primary_key: true
    end

    create table(:snaps, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
      add :description, :text
      add :url, :text
      add :memento_id, :uuid, null: false
    end

    create table(:mementos, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
    end

    alter table(:snaps) do
      modify :memento_id,
             references(:mementos,
               column: :id,
               name: "snaps_memento_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:mementos) do
      add :name, :text
      add :description, :text

      add :user_id,
          references(:users,
            column: :id,
            name: "mementos_user_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:mementos, "mementos_user_id_fkey")

    alter table(:mementos) do
      remove :user_id
      remove :description
      remove :name
    end

    drop constraint(:snaps, "snaps_memento_id_fkey")

    alter table(:snaps) do
      modify :memento_id, :uuid
    end

    drop table(:mementos)

    drop table(:snaps)

    drop table(:tokens)

    drop_if_exists unique_index(:users, [:email], name: "users_unique_email_index")

    drop table(:users)
  end
end