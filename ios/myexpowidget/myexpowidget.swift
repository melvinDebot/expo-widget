//
//  myexpowidget.swift
//  myexpowidget
//
//  Created by Melvin on 21/04/2025.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
  let userDefaultsKey = "storedNumber"
  
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), value: getValue())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, value: getValue())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        //var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //let currentDate = Date()
        //for hourOffset in 0 ..< 5 {
            //let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            //let entry = SimpleEntry(date: entryDate, configuration: configuration, value: getValue())
            //entries.append(entry)
        //}

        //return Timeline(entries: entries, policy: .atEnd)
      
      return Timeline(entries: [SimpleEntry(date: .now, configuration: configuration, value: getValue())], policy: .after(.now.advanced(by: 60 * 5)))
    }
  
  private func getValue() ->Int {
    if let userDefaults = UserDefaults(suiteName: "group.com.verseapp.dailyQuotes") {
      let storedValue = userDefaults.integer(forKey: userDefaultsKey)
      return storedValue
    }else {
      return 0
    }
  }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let value: Int
}

struct myexpowidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\(entry.value)")
            Button(intent: IncrementIntent()) {
                Text("Increment value")
            }
        }
    }
}

struct myexpowidget: Widget {
    let kind: String = "myexpowidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            myexpowidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

import AppIntents

struct IncrementIntent: AppIntent {
    let userDefaultsKey = "storedNumber"

    static var title: LocalizedStringResource = "Increment value"

    func perform() async throws -> some IntentResult {
        if let userDefaults = UserDefaults(suiteName: "group.com.verseapp.dailyQuotes") {
            let currentValue = userDefaults.integer(forKey: userDefaultsKey)
            let newValue = currentValue + 1
            userDefaults.set(newValue, forKey: userDefaultsKey)
        }

        return .result()
    }
}

#Preview(as: .systemSmall) {
    myexpowidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .smiley, value: 1)
  SimpleEntry(date: .now, configuration: .starEyes, value: 1)
}
