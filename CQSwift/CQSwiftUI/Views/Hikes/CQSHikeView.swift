/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying information about a CQSHike, including an elevation graph.
*/

import SwiftUI

extension AnyTransition {
    static var moveAndFade : AnyTransition {
        //AnyTransition.move(edge: .trailing)
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity))
    }
}

struct CQSHikeView: View {
    var hike: CQSHike
    @State private var showDetail = false

    var body: some View {
        VStack {
            HStack {
                CQSHikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)

                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        //.animation(nil, value: showDetail)
                        .scaleEffect(showDetail ? 1.5 : 1.0)
                        .padding()
                        //.animation(.spring(), value: showDetail)
                }
            }

            if showDetail {
                CQSHikeDetail(hike: hike)
                    .transition(.moveAndFade)
                    //.transition(.slide)
            }
        }
    }
}

struct CQSHikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CQSHikeView(hike: CQSModelData().hikes[0])
                .padding()
            Spacer()
        }
    }
}
