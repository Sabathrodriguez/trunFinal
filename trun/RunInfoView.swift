//
//  RunInfoView.swift
//  trun
//
//  Created by Sabath  Rodriguez on 12/7/24.
//

import SwiftUI
import SwiftData

struct RunInfoView: View {
    @Binding var selectedRun: Pace?
    @Binding var runTypeDict: [Pace: Double]
    @Binding var runningMenuHeight: PresentationDetent
    
    @State var searchWasClicked = false
    @State var searchField: String = ""
        
    var body: some View {
        
        HStack {
            // button will allow user to search location
            HStack {
                Button(action: {
                    runningMenuHeight = .large
                    searchWasClicked = true
                }) {
                    if (searchWasClicked) {
                        HStack {
                            Image(systemName: "magnifyingglass") // Using SF Symbols for the icon
                                .foregroundColor(.gray)
                                .padding(Edge.Set([.leading]))
                            
                            TextField("Search", text: $searchField)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(height: 40)
                        .background(Color(.systemGray6)) // Light gray background
                        .cornerRadius(20)
                        .padding(Edge.Set([.top, .leading, .bottom]))
                        
                        Button("Cancel", action: {
                            searchWasClicked = false
                        })
                        .padding(Edge.Set([.trailing]))
                    } else {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                    //                                            .border(Color.gray, width: 1)
                }
                if (!searchWasClicked) {
                    Spacer()
                    // this simply outputs whatever is selected from picker
                    if let selectedRun {
                        let twoDecimalPlaceRun = String(format: "%.2f", runTypeDict[selectedRun]!)
                        let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
                        Text("Running at \(twoDecimalPlaceRunArray[0]):\(twoDecimalPlaceRunArray[1])/mile")
                            .font(.title2)
                            .foregroundColor(Color.black)
                            .bold()
                            .frame(width:150, height:55)
                        //                                            .border(Color.black, width: 1)
                    } else {
                        Text("Select a run type")
                    }
                    Spacer()
                    // this will locate the user based on the phone gps
                    Button(action: {
                        print("location clicked")
                    }) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color.blue)
                            .padding()
                        //                                            .border(Color.blue, width: 1)
                    }
                }
            }
        }
    }
}
