[recurse(.["key.substructure"][]?) |
  select(."key.kind" | tostring | startswith("source.lang.swift.decl.function")) |
  select((."key.name" | length) > 20) |
  ."key.name"]
