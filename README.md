# Wheres #

### Layered Architecture ###

All application's code is divided on actors:

* **Views** contains custom views
* **ViewControllers** custom view controllers
* **ViewModels** services view controllers, intermediate between view controller and model
* **Models** contains entities and domain model objects that implement business logic
* **Services** service model implement concrete work, as to save something to DB

The relationship between these actors is next:
```
|------------------|     |-------------|     |---------|     |-----------|
|  ViewController  | ––> |  ViewModel  | ––> |  Model  | ––> |  Service  |
|------------------|     |-------------|     |---------|     |-----------|
```

```
|------------------|     |-------------|     |---------|     |-----------|
|  ViewController  | <-- |  ViewModel  | <-- |  Model  | <-- |  Service  |
|------------------|     |-------------|     |---------|     |-----------|
```

The `––>` arrows indicates direct usage (meaning reference) and `<--` indirect usage such as delegate/notification handling/observing/callbacks/etc