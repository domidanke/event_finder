enum UserType {
  base,
  artist,
  host;

  static UserType fromString(String json) => values.byName(json);
}
