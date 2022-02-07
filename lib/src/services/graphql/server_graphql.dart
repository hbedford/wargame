class ServerGraphQL {
  ServerGraphQL._();
  static String openServer(int userId) => """
    mutation {
      insert_server(objects: {host_user_id: $userId, server_user: {data: {user_id: $userId}}}) {
        returning {
          id
          user {
            id
            email
            name
          }
          isstarted
          server_users {
            user {
              id
              name
            email
            }
          }
          server_users_aggregate {
            aggregate {
              count
            }
          }
        }
      }
    }
    """;
  static String startGame(int serverId) => """
  mutation {
    update_server(where: {id: {_eq: 10}}, _set: {isstarted: true}) {
      affected_rows
    }
  }
  """;
  static String get listenServers => """ 
    subscription {
      server {
        id
        first_user_id
        selected_user_id
        isstarted
        server_users {
            user {
              id
              name
              email
            }
          }
        user {
          id
          name
          email
        }
        server_users_aggregate {
          aggregate {
            count
          }
        }
      }
    }
  """;

  static String connectToServer(int serverId, int userId) => """
    mutation {
      insert_server_users(objects: {server_id: $serverId, user_id: $userId}) {
        affected_rows
        returning{
          server {
        id
        first_user_id
        selected_user_id
        isstarted
        server_users {
            user {
              id
              name
              email
            }
          }
        user {
          id
          name
          email
        }
        server_users_aggregate {
          aggregate {
            count
          }
        }
      }
        }
      }
    }
  """;

  static String addTerritories(List<Map<String, dynamic>> list) => """
    mutation MyMutation(\$objects:[territory_insert_input!]!) {
      insert_territory(objects:\$objects ) {
        affected_rows
      }
    }
    """;
}
