enum UserType {
  base,
  artist,
  host;

  static UserType fromJson(String json) => values.byName(json);
}
