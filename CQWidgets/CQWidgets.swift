//
//  CQWidgets.swift
//  CQWidgets
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> CQEntry {
        if context.isPreview {
            return CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "占位符")
        } else {
            return CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "-----")
        }
    }

    func getSnapshot(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (CQEntry) -> ()) {
        let entry = CQEntry(date: Date(), configuration: configuration, placeContent: "笑😊")
        completion(entry)
    }

    func getTimeline(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CQEntry] = []

        //从当前日期开始，生成一个由五个条目组成的时间线，间隔一小时。
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CQEntry(date: entryDate, configuration: configuration, placeContent: "占位符")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CQEntry: TimelineEntry {
    let date: Date
    let configuration: CQConfigurationIntent
    let placeContent:String
}

struct CQWidgetsEntryView : View {
    var entry: Provider.Entry

//    var body: some View {
//        Text(entry.date, style: .time)
//    }
    
    @Environment(\ .widgetFamily) var family:WidgetFamily

    //@ViewBuilder声明主体，因为它使用的视图类型各不相同
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                VStack {
                    Text(entry.date, style: .time) 
                    if #available(iOSApplicationExtension 16.0, *) {
                        Text(entry.placeContent)
                            .font(.system(.body, weight: .bold))
                    } else {
                        Text(entry.placeContent)
                            .font(.system(size: 17.0))

                    }
                }
                .padding(.zero)
            }
            .background(Color.orange)

        default:
            ZStack {
                VStack {
                    Text(entry.date, style: .time)
                    if #available(iOSApplicationExtension 16.0, *) {
                        Text(entry.placeContent)
                            .font(.system(.body, weight: .bold))
                    } else {
                        Text(entry.placeContent)
                            .font(.system(size: 17.0))

                    }
                }
                .padding(.zero)
            }
            .background(Color.orange)
        }
    }
}

@main
struct CQWidgets: Widget {
    let kind: String = "CQWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CQConfigurationIntent.self, provider: Provider()) { entry in
            CQWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("您好！")
        .description("欢迎添加 widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemMedium])
    }
}

struct CQWidgets_Previews: PreviewProvider {
    static var previews: some View {
        CQWidgetsEntryView(entry: CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "占位符"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
