//
//  ContentView.swift
//  trun
//
//  Created by Sabath  Rodriguez on 11/16/24.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    
    @State private var selectedRun: Pace? = .CurrentMile
    // this will need to be updated to retrieve actual run values
    @State private var runTypeDict: [Pace: Double] = [Pace.Average: 1, Pace.Current: 2, Pace.CurrentMile: 3]
    @State var showSheet: Bool = true
    @State var runningMenuHeight: PresentationDetent = PresentationDetent.height(300)
    
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    
    private var runningMenuHeights = Set([PresentationDetent.height(300), PresentationDetent.height(100), PresentationDetent.large])
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // background map
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.checkIfLocationServicesEnabled()
                    }
                    .sheet(isPresented: $showSheet) {
                        RunView(selectedRun: $selectedRun, runTypeDict: $runTypeDict, runningMenuHeight: $runningMenuHeight, userRegion: viewModel)
                            .presentationBackgroundInteraction(.enabled)
                            .presentationDetents(runningMenuHeights, selection: $runningMenuHeight)
                        .interactiveDismissDisabled(true)
                    }
                VStack(alignment: .center) {
                    Spacer(minLength: 550)
//                    .offset(y: geometry.size.height / 2 + 40)
//                    .border(Color.red, width: 1)
                    .frame(height: 100)
                    
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 80)
                .frame(height: 600)
//                .border(Color.red, width: 1)
                .offset(y: geometry.size.height / 2 + 50)
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
