/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a hike.
*/

import SwiftUI

struct CQSHikeDetail: View {
    let hike: CQSHike
    @State var dataToShow = \CQSHike.CQSObservation.elevation

    var buttons = [
        ("Elevation", \CQSHike.CQSObservation.elevation),
        ("Heart Rate", \CQSHike.CQSObservation.heartRate),
        ("Pace", \CQSHike.CQSObservation.pace)
    ]

    var body: some View {
        VStack {
            CQSHikeGraph(hike: hike, path: dataToShow)
                .frame(height: 200)

            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button {
                        dataToShow = value.1
                    } label: {
                        Text(value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == dataToShow
                                ? .gray
                                : .accentColor)
                            .animation(nil)
                    }
                }
            }
        }
    }
}

struct CQSHikeDetail_Previews: PreviewProvider {
    static var previews: some View {
        CQSHikeDetail(hike: CQSModelData().hikes[0])
    }
}
