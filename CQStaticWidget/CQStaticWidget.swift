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
                
                // systemSmall(小号组件)只能用widgetURL修饰符实现URL传递接收。
                // systemMedium、systemLarge可以用Link或者 widgetUrl处理
                // 点击不同区域传递不同URL
                let url = URL(string: "\(widgetScheme)\(title)")!
                Link(destination: url) {
                    Label(title, systemImage: "paperplane.circle.fill")
                        .padding(10.0)
                        .frame(height: 30.0)
                        .background(.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                    //.widgetURL(url)
                    
                Spacer()
            }
            .foregroundColor(.white)
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
        .supportedFamilies([.systemMedium])
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


//@main
struct CQWidgetBundle: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        CQStaticWidget()
        CQWidgets()
        CQStaticWidget2()
    }

}
