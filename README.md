# 📱 React Native + Expo — Intégration d'un Widget iOS

Ce guide explique comment créer une app **Expo** avec un **widget iOS** intégré, en utilisant un module natif (`expo-module`) pour faire communiquer votre app JavaScript avec Swift via `UserDefaults`.

---

## 🧰 Prérequis

- macOS avec Xcode installé
- Node.js + npm
- Expo CLI installé (`npm install -g expo-cli`)
- iOS device ou simulateur

---

## 🚀 Étapes

### ✅ 1. Créer une app avec Expo + Dev Client

```bash
npx create-expo-app my-widget-app
cd my-widget-app
npx expo install expo-dev-client
```
---

### 🧪 2. Lancer sur simulateur
```bash
npx expo run:ios
```
Vous devriez voir votre app apparaître sur le simulateur ou iPhone (connecté).
---

### ⚙️ 3. Créer un module natif Swift (bridge)
```bash
npx create-expo-module@latest --local
```
Ensuite :

```bash
pod install --project-directoy=ios
```

### 📦 4. Structure du module MyModule
MyModule.ts (Interface JS → Swift)
```ts
declare class MyModule extends NativeModule<MyModuleEvents> {
  PI: number; // Exemple de constante native
  hello(): string; // Retourne une string depuis Swift
  setValueAsync(value: string): Promise<void>; // Stocke une valeur
  saveValue(): number; // Incrémente et retourne la nouvelle valeur
  getValue(): number; // Lit la valeur actuelle
}
```
MyModule.swift (Code natif)
```swift
private let userDefaultsKey = "storedNumber"
```
Clé partagée entre l’app et le widget via UserDefaults (utilise un App Group)

```swift
struct IncrementIntent: AppIntent {
    let userDefaultsKey = "storedNumber"

    static var title: LocalizedStringResource = "Increment value"

    func perform() async throws -> some IntentResult {
        if let userDefaults = UserDefaults(suiteName: "group.com.ve") {
            let currentValue = userDefaults.integer(forKey: userDefaultsKey)
            let newValue = currentValue + 1
            userDefaults.set(newValue, forKey: userDefaultsKey)
        }

        return .result()
    }
}
```
Incrémente la valeur stockée et la retourne

---
### 🧪 5. Utilisation dans React Native
```tsx
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import MyModule from "./modules/my-module/src/MyModule";
import { useEffect, useState } from "react";
```
Chargement de la valeur :
```tsx
useEffect(() => {
    setValue(MyModule.getValue());
  }, []);
```
Affichage et mise à jour :
```tsx
<TouchableOpacity onPress={() => setValue(MyModule.saveValue())}>
  <Text>Update</Text>
</TouchableOpacity>
<Text>Value: {value}</Text>
```
On affiche la valeur lue et on la met à jour lors du clic

---
### 🧩 6. Créer un widget iOS
1. Ouvrir le projet :
```bash
open ios/YourApp.xcworkspace
```
2.	File > New > Target > Widget Extension
3.	Sélectionner un nom comme myexpowidget
4.	Dans Signing & Capabilities, activer App Groups, ajouter : group.com.verseapp.dailyQuotes (même que dans Swift)

### Vue SwiftUI du widget
```swift
struct myexpowidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    VStack {
      Text("\(entry.value)") // Affiche la valeur lue
      Button(intent: IncrementIntent()) {
        Text("Increment value") // Appelle un AppIntent natif
      }
    }
  }
}
```

### 🧪 Tester le widget
- Lancer l’app avec npx expo run:ios
- Mettre à jour la valeur dans l’app
- Ajouter le widget depuis l’écran d’accueil
- Tester le bouton “Increment value”

### 🔐 App Groups
Obligatoire pour partager des données entre app et widget

- Dans Xcode :
- Target App et Widget → Signing & Capabilities
- Ajoute : group.com.verseapp.dailyQuotes
- Utilisé avec :
```swift
UserDefaults(suiteName: "group.com.verseapp.dailyQuotes")
```

### Source

