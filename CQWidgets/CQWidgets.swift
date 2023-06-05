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
    
//    var requestStatus: Bool = true // 从服务器请求数据的状态
    var requestMessages = [
        "读书之法，在循序而渐进，熟读而精思。",
        "读书不觉已春深，一寸光阴一寸金",
        "总会有不期而遇的温暖。",
        "路虽远行则将至，事虽难做则必成。",
        "横空出世，莽昆仑，阅尽人间春色。",
    ]
    
    //占位视图，第一次展示小组件都会展示这个。
    // 网络请求失败、发生未知错误
    func placeholder(in context: Context) -> CQEntry {
        return CQEntry(date: Date(), configuration: CQConfigurationIntent(), placeContent: "-----")
    }

    // 提供预览快照，默认值
    func getSnapshot(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (CQEntry) -> ()) {
        if context.isPreview {
            // 在小组件库中显示您的小部件，添加小组件时预览的样式
            let entry = CQEntry(date: Date(), configuration: configuration, placeContent: "往者不可谏，来者犹可追。")
            completion(entry)
        }
    }

    // 在请求初始快照后，调用该方法。请求常规时间线
    func getTimeline(for configuration: CQConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        CQNetManager.manager.downLoadImage { image in
            let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            let entry = CQEntry(date: entryDate, configuration: configuration, placeContent: requestMessages[1], image: image)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } failure: { message in
//            let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
//            let entry = CQEntry(date: entryDate, configuration: configuration, placeContent: message)
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
            let entry = self.placeholder(in: context)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
        
        
//        var entries: [CQEntry] = []
//
//        //configuration.CQFunc
//        //从当前日期开始，生成一个由五个条目组成的时间线，间隔一小时。
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            //间隔一小时。
//            //let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            //间隔15分钟。
//            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 15, to: currentDate)!
//            let entry = CQEntry(date: entryDate, configuration: configuration, placeContent: requestMessages[hourOffset])
//            entries.append(entry)
//        }
//
//        /*  policy: 加载策略。
//         *  atEnd: 最后一个日期过后请求新的时间线
//         *  never: 在新的时间线可用时提示WidgetKit
//         *  after(_ date: Date): 指定WidgetKit请求新时间线的未来日期。
//         */
//        //let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 60)))
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
}

// 时间线条目
struct CQEntry: TimelineEntry {
    let date: Date
    let configuration: CQConfigurationIntent
    let placeContent:String
    var image:Image? = nil
}

struct CQWidgetsTitleView : View {
    var entry: Provider.Entry
    var body: some View {
        HStack {
            Spacer()
            VStack {
                // configuration: 小组件的配置
                let function = entry.configuration.CQFunc.rawValue
                Text(String(function))
                    .font(.system(size: 17, weight: .bold))
                let dateString = entry.date.convertToString("yyyy-MM-dd HH:mm:ss")
                Text(dateString)
                    .font(.system(size: 12, weight: .bold))
            }
            Spacer()
        }
        .foregroundColor(.white)
    }
    
    
}
struct CQWidgetsDescriptionView : View {
    @Binding var entry: Provider.Entry
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
        .background( Color.pink.opacity((entry.image == nil) ? 1.0 : 0.0))
    }
}

//struct CQWidgetsImgView:View {
//    let url:URL
//    var body: some View {
//        if #available(iOSApplicationExtension 15.0, *) {
//            AsyncImage(url: url) { img in
//                img
//                    .resizable()
//                    .scaledToFill() // 按比例填充
//            } placeholder: {
//
//            }
//
//        } else {
//            if let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
//               let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
//                Image(cgImage, scale: 1.0, label: Text(""))
//                    .resizable()
//                    .scaledToFill() // 按比例填充
//            } else {
//                Image("placeholder")
//                    .resizable()
//                    .scaledToFill() // 按比例填充
//            }
//        }
//    }
//}

struct CQWidgetsEntryView : View {
    @State var entry: Provider.Entry
    
    @Environment(\ .widgetFamily) var family:WidgetFamily

    //@ViewBuilder声明主体，因为它使用的视图类型各不相同
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                if let image = entry.image {
                    image
                        .resizable()
                        .scaledToFill()
                }
                VStack {
                    CQWidgetsTitleView(entry: entry)
                        .padding([.top, .bottom], 10)
                    CQWidgetsDescriptionView(entry: $entry)
                }
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
