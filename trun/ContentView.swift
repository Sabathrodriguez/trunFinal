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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Map()
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: $showSheet, content: {
                        HStack {
                            Text("this is the stack")
                        }.presentationDetents([.medium])
                    })
                VStack(alignment: .center) {
                    Spacer(minLength: 550)
                    Image(systemName: "line.diagonal")
                    HStack {
                        Spacer()
                        Button(action: {
                            print("search clicked")
                            
                        }) {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .resizable()
                                .foregroundColor(Color.gray)
                                .frame(width: 55, height: 55)
                                .foregroundStyle(.gray)
//                                .border(Color.gray, width: 1)
//                                .padding()
                        }
                        Spacer()
                        if let selectedRun {
                            let twoDecimalPlaceRun = String(format: "%.2f", runTypeDict[selectedRun]!)
                            let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
                            Text("Running at \(twoDecimalPlaceRunArray[0]):\(twoDecimalPlaceRunArray[1])/mile")
                                .font(.title2)
                                .foregroundColor(Color.black)
                                .bold()
                        } else {
                            Text("Select a run type")
                        }
                       
                        Spacer()
                        Button(action: {
                            print("location clicked")
                        }) {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color.blue)
//                                .padding()
//                                .border(Color.blue, width: 1)
                        }
                        Spacer()
                    }
//                    .offset(y: geometry.size.height / 2 + 40)
//                    .border(Color.red, width: 1)
//                    .border(Color.black, width: 1)
                    
                    List {
                        Picker("Info", selection: $selectedRun) {
                            Text("Current Pace").tag(Pace.Current)
                            Text("Current Mile Pace").tag(Pace.CurrentMile)
                            Text("Average Run Pace").tag(Pace.Average)
                        }
                    }
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

enum Pace {
    case Current, CurrentMile, Average
    var id: Self {self}
}

#Preview {
    ContentView()
}
