enum UserType {
  guest,
  base,
  artist,
  host;

  static UserType fromString(String json) => values.byName(json);
}
