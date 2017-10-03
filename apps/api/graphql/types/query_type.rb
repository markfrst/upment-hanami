# frozen_string_literal: true

module Types
  QueryType = GraphQL::ObjectType.define do
    name 'Query'
    description 'The query root for this schema'

    # http://api.lvh.me:2300/graphql?query={user(id: 1){ id, first_name, last_name }}
    field :user, field: Fetch::Field.build(model: UserRepository, type: UserType)

    # http://api.lvh.me:2300/graphql?query={users{ id, first_name, last_name }}
    field :users, field: Fetch::Collection.build(model: UserRepository, type: UserType)
  end
end