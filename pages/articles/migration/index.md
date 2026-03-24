---
title: Migration
parent: Articles
---

```ptls
cities = import "csv:cities.csv"
```

```ptls
print(cities)
```

```ptls
print(len(cities))
```

```ptls
cities
  | take(5)
  | print
```

```ptls
cities
  | takeLast(5)
  | print
```

```ptls
cities
  | take(10)
  | takeLast(5)
  | print
```

```ptls
print(cities[5])
```

```ptls
print(cities[5].state)
```

```ptls
print(Table.columns(cities))
```

```ptls
cities
  | select(["city", "pop2024"])
  | print
```

```ptls
cities
  | take(10)
  | select(["city", "pop2024"])
  | print
```

```ptls
print(cities.state)
```

```ptls
print(cities.state[5])
```

```ptls
cities
  | remove(["pop2020", "area"])
  | print
```

```ptls
cities
  | Table.rename({ area: "areaSqMiles" })
  | print
```

```ptls
cities
  # { density: arg.pop2024 / arg.area }
  | roundTo(1)
  | print
```

```ptls
cities
  # {
    popChange: arg.pop2024 - arg.pop2020,
    pctChange: arg.pop2024 / arg.pop2020 * 100 - 100,
  }
  | print
```

```ptls
cities
  ? arg.state == "PA"
  | print
```

```ptls
cities
  ? arg.state == "TX" and arg.pop2024 > 1000000
  | print
```

```ptls
cities
  ? arg.state in ["MA", "PA"]
  | print
```

```ptls
cities
  | sortDescBy("area")
  | print
```

```ptls
cities
  | sortBy("city")
  | print
```

```ptls
cities
  # { popChange: arg.pop2024 - arg.pop2020 }
  | remove(["pop2024", "pop2020"])
  | Table.top("popChange", 10)
  | print
```

```ptls
cities
  | select(["state", "pop2024", "area"])
  | Table.summarize("state", sum)
  | sortDescBy("pop2024")
  | print
```

```ptls
cities
  | Table.summarize("state", fn(g) Table.maxBy(g, "pop2024"))
  | sortBy("state")
  | print
```

```ptls
cities
  | select("state")
  | Table.countAll
  | remove("share")
  | print
```

```ptls
cities
  | Table.summarize("state", fn(g) { popChange: sum(g.pop2024) - sum(g.pop2020) })
  | sortDescBy("popChange")
  | print
```
