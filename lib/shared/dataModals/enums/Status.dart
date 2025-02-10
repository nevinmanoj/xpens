enum Status {
  active,
  upcoming,
  closed,
}

String serializeStatus(Status s) => s.name;

Status deserializeStatus(String s) =>
    Status.values.firstWhere((e) => e.name == s);
