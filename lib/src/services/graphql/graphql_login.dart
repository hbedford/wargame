class GraphQLLogin {
  GraphQLLogin._();
  static String login({required String email}) => """
    query {
      user(where: {email: {_eq: "$email"}}) {
        email
        id
        name
      }
    }
  """;
  static String register({required String email, required String name}) => """
    mutation {
      insert_user(objects: {email: "$email", name: "$name"}) {
        returning {
          id
          name
          email
        }
        affected_rows
      }
    }
    """;
}
