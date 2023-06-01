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
    
    var requestStatus: Bool = true // 从服务器请求数据的状态
    var requestMessages = [
        "读书之法，在循序而渐进，熟读而精思。",
        "读书不觉已春深，一寸光阴一寸金",
        "总会有不期而遇的温暖。",
        "路虽远行则将至，事虽难做则必成。",
        "横空出世，莽昆仑，阅尽人间春色。",
    ]
    
    //占位视图，例如网络请求失败、发生未知错误、第一次展示小组件都会展示这个view
    func placeholder(in context: Context) -> CQEntry {
        if context.isPreview { // 在小部件库中显示您的小部件
            return CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "丈夫之四海，万里犹比邻。")
        } else {
            return CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "-----")
        }
    }

    // 提供预览快照，默认值
    func getSnapshot(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (CQEntry) -> ()) {
        let entry: CQEntry
        if context.isPreview && !requestStatus { // 在小部件库中显示您的小部件
            entry = CQEntry(date: Date(), configuration: configuration, placeContent: "往者不可谏，来者犹可追。")
        } else {
            entry = CQEntry(date: Date(), configuration: configuration, placeContent: "不用谁施舍阳光，你自己就是太阳。")
        }
        completion(entry)
    }

    // 在请求初始快照后，调用该方法。请求常规时间线
    func getTimeline(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CQEntry] = []

        //configuration.CQFunc
        
        //从当前日期开始，生成一个由五个条目组成的时间线，间隔一小时。
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            //间隔一小时。
            //let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            //间隔15分钟。
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 15, to: currentDate)!
            let entry = CQEntry(date: entryDate, configuration: configuration, placeContent: requestMessages[hourOffset])
            entries.append(entry)
        }
 
        /*  policy: 加载策略。
         *  atEnd: 最后一个日期过后请求新的时间线
         *  never: 在新的时间线可用时提示WidgetKit
         *  after(_ date: Date): 指定WidgetKit请求新时间线的未来日期。
         */
        //let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 60)))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// 时间线条目
struct CQEntry: TimelineEntry {
    let date: Date
    let configuration: CQConfigurationIntent
    let placeContent:String
}

struct CQWidgetsTitleView : View {
    var entry: Provider.Entry
    var body: some View {
        HStack {
            Spacer()
            Text(entry.date, style: .time)
                .foregroundColor(.white)
            Spacer()
        }
    }
}
struct CQWidgetsDescriptionView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(entry.placeContent)
                    .font(.system(size: 15.0, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            Spacer()
        }
    }
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
            VStack {
                CQWidgetsTitleView(entry: entry)
                    .padding([.top, .bottom], 10)
                CQWidgetsDescriptionView(entry: entry)
                    .background(Color.pink.opacity(1.0))
            }
        default:
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(entry.date, style: .time)
                    Spacer()
                    if #available(iOSApplicationExtension 16.0, *) {
                        Text(entry.placeContent)
                            .font(.system(.body, weight: .bold))
                    } else {
                        Text(entry.placeContent)
                            .font(.system(size: 17.0))

                    }
                    Spacer()
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

@main
struct CQWidgets: Widget {
    let kind: String = "CQWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CQConfigurationIntent.self, provider: Provider()) { entry in
            
            CQWidgetsEntryView(entry: entry)
                .background(Color.pink.opacity(0.9))
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
