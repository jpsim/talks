[recurse(.["key.substructure"][]?) |
  select(."key.accessibility" == "source.lang.swift.accessibility.public") |
  ."key.name"?]
