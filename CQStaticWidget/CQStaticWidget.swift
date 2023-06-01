//
//  CQStaticWidget.swift
//  CQStaticWidget
//
//  Created by llbt2019 on 2023/6/1.
//  Copyright © 2023 李超群. All rights reserved.
//

import WidgetKit
import SwiftUI

struct StaticProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CQStaticWidgetEntryView : View {
    var entry: StaticProvider.Entry
    
    let list:[String] = [
        "collectionView",
        "tableView",
        "swiftUI"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            ForEach(list, id: \.self) { title in
                Label(title, image: "paperplane.circle.fill")
                    .padding(5.0)
                    .border(.gray, width: 1.0)
                    .cornerRadius(3.0)
                    .background(.purple)
                    .widgetURL(URL(string: "widget://\(title)"))
                    //.shadow(color: .red, radius: 7)
                Spacer()
            }
        }
    }
}
struct CQStaticWidgetEntryView2 : View {
    var entry: StaticProvider.Entry
    
    var body: some View {
        Label("WidgetBundle", image: "paperplane.circle.fill")
    }
}
//@main
struct CQStaticWidget: Widget {
    let kind: String = "CQStaticWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StaticProvider()) { entry in
            CQStaticWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("静态Widget1")
        .description("This is an example widget1.")
        .supportedFamilies([.systemSmall])
    }
}

struct CQStaticWidget2: Widget {
    let kind: String = "CQStaticWidget2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StaticProvider()) { entry in
            CQStaticWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("静态Widget2")
        .description("This is an example widget2.")
        .supportedFamilies([.systemSmall])
    }
}


@main
struct CQWidgetBundle: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        CQStaticWidget()
        CQWidgets()
        CQStaticWidget2()
    }

}
