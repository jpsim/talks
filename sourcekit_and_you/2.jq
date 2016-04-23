[."key.substructure"[] | select(."key.kind" == "source.lang.swift.decl.struct") |
  {key: ."key.name", value: [
    (."key.substructure"[] |
      select(."key.kind" == "source.lang.swift.decl.function.method.instance") |
      ."key.name")]}
] | from_entries
