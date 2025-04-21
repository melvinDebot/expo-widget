import ExpoModulesCore

public class MyModule: Module {
  let userDefaultsKey = "storedNumber"
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('MyModule')` in JavaScript.
    Name("MyModule")

    // Sets constant properties on the module. Can take a dictionary or a closure that returns a dictionary.
    Constants([
      "PI": Double.pi
    ])

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("hello") {
      return "Hello world! 👋"
    }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", [
        "value": value
      ])
    }

    // Enables the module to be used as a native view. Definition components that are accepted as part of the
    // view definition: Prop, Events.
    View(MyModuleView.self) {
      // Defines a setter for the `url` prop.
      Prop("url") { (view: MyModuleView, url: URL) in
        if view.webView.url != url {
          view.webView.load(URLRequest(url: url))
        }
      }

      Events("onLoad")
    }

    Function("getValue"){
      if let userDefaults = UserDefaults(suiteName: "group.com.verseapp.dailyQuotes") {
        let storedValue = userDefaults.integer(forKey: userDefaultsKey)
        return storedValue
      } else {
        return 0
      }
    }

    Function("saveValue"){
      if let userDefaults = UserDefaults(suiteName: "group.com.verseapp.dailyQuotes") {
        let currentValue = userDefaults.integer(forKey: userDefaultsKey)
        let newValue = currentValue + 1
        userDefaults.set(newValue, forKey: userDefaultsKey)
        return newValue
      } else {
        return 0
      }
    }
  }
}
