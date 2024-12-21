//
//  RunInfoView.swift
//  trun
//
//  Created by Sabath  Rodriguez on 12/7/24.
//

import SwiftUI
import SwiftData
import MapKit

struct RunInfoView: View {
    @Binding var selectedRun: Pace?
    @Binding var runTypeDict: [Pace: Double]
    @Binding var runningMenuHeight: PresentationDetent
    @Binding var searchWasClicked: Bool

    @State var inRunningMode: Bool = false
    @State var isPaused: Bool = false
    @State private var isLongPressing = false
    @State var searchField: String = ""
    
    @FocusState var isSearchFieldFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var region: ContentViewModel
    
    var iconHeightAndWidth: CGFloat = 75
            
    var body: some View {
        
        HStack {
            if (runningMenuHeight == .height(100)) {
                if let selectedRun {
                    let twoDecimalPlaceRun = String(format: "%.2f", runTypeDict[selectedRun]!)
                    let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
                    Text("Running at \(twoDecimalPlaceRunArray[0]):\(twoDecimalPlaceRunArray[1])/mile")
                        .font(.title2)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .bold()
                        .padding(.top, 30)
                    //                                            .border(Color.black, width: 1)
                } else {
                    Text("Select a run type")
                        .padding(.top, 30)
                }
            } else if (searchWasClicked && runningMenuHeight == .large) {
                HStack {
                    Image(systemName: "magnifyingglass") // Using SF Symbols for the icon
                        .foregroundColor(.gray)
                        .padding(Edge.Set([.leading]))
                    
                    TextField("Search", text: $searchField)
                        .multilineTextAlignment(.leading)
                        .focused($isSearchFieldFocused)
                }
                .frame(height: 40)
                .background(Color(.systemGray6)) // Light gray background
                .cornerRadius(20)
                .padding(Edge.Set([.top, .leading, .bottom]))
                
                Button("Cancel", action: {
                    searchWasClicked = false
                    runningMenuHeight = .height(250)
                })
                .padding(Edge.Set([.trailing]))
            } else {
                if (!inRunningMode) {
                    // button will allow user to search location
                    Button(action: {
                        runningMenuHeight = .large
                        searchWasClicked = true
                        isSearchFieldFocused = true
                    })
                    {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                            .foregroundColor(Color.gray)
                            .overlay(content: {
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                            })
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            print("GO was clicked")
                            inRunningMode = true
                        }) {
                            Circle()
                                .frame(width: 120, height: 120)
                                .foregroundColor(Color.green)
                                .overlay(content: {
                                    Circle()
                                        .stroke(.black, lineWidth: 2)
                                })
                                .overlay {
                                    Text("GO")
                                        .foregroundColor(Color.black)
                                        .fontWeight(.bold)
                                        .font(.title)
                                }
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    // this will locate the user based on the phone gps
                    Button(action: {
                        print("location clicked")
                        region.checkLocationAuthorization()
                    }) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                            .foregroundColor(Color.blue)
                            .overlay(content: {
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                            })
                            .padding()
                        //                                            .border(Color.blue, width: 1)
                    }
                } else {
                    if (isPaused) {
                        VStack {
                            // this simply outputs whatever is selected from picker
                            if let selectedRun {
                                let twoDecimalPlaceRun = String(format: "%.2f", runTypeDict[selectedRun]!)
                                let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
                                Text("Running at \(twoDecimalPlaceRunArray[0]):\(twoDecimalPlaceRunArray[1])/mile")
                                    .font(.title2)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .bold()
                                    .padding(.top, 30)
                                //                                            .border(Color.black, width: 1)
                            } else {
                                Text("Select a run type")
                                    .padding()
                            }
                            HStack {
                                
                                // button will allow user to search location
                                Button(action: {
//                                    runningMenuHeight = .large
                                    print("pressed camera")
                                })
                                {
                                    Image(systemName: "camera.circle.fill")
                                        .resizable()
                                        .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                                        .foregroundColor(Color.gray)
                                        .overlay(content: {
                                            Circle()
                                                .stroke(.black, lineWidth: 1)
                                        })
                                        .padding()
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
//                                        print("Pause was clicked")
//                                        isPaused = false
//                                        inRunningMode = false
                                    })
                                    {
                                    Circle()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(Color.orange)
                                        .overlay(content: {
                                            Circle()
                                                .stroke(.black, lineWidth: 2)
                                        })
                                        .overlay {
                                            Text("Paused")
                                                .foregroundColor(Color.black)
                                                .fontWeight(.bold)
                                                .font(.title)
                                        }
                                        .padding()
                                    }
                                    .simultaneousGesture(LongPressGesture(minimumDuration: 3).onEnded { _ in
                                        print("Secret Long Press Action!")
                                        inRunningMode = false
                                    })
                                    .simultaneousGesture(TapGesture().onEnded {
                                        print("Pause was clicked")
                                        isPaused = false
                                    })
                                }
                                Spacer()
                                
                                // this will locate the user based on the phone gps
                                Button(action: {
                                    print("location clicked")
                                    region.checkLocationAuthorization()
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .resizable()
                                        .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                                        .foregroundColor(Color.blue)
                                        .overlay(content: {
                                            Circle()
                                                .stroke(.black, lineWidth: 1)
                                        })
                                        .padding()
                                    //                                            .border(Color.blue, width: 1)
                                }
                            }
                            }
                    } else {
                    VStack {
                        // this simply outputs whatever is selected from picker
                        if let selectedRun {
                            let twoDecimalPlaceRun = String(format: "%.2f", runTypeDict[selectedRun]!)
                            let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
                            Text("Running at \(twoDecimalPlaceRunArray[0]):\(twoDecimalPlaceRunArray[1])/mile")
                                .font(.title2)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .bold()
                                .padding(.top, 30)
                            //                                            .border(Color.black, width: 1)
                        } else {
                            Text("Select a run type")
                                .padding()
                        }
                        HStack {
                            
                            // button will allow user to search location
                            Button(action: {
//                                runningMenuHeight = .large
                                print("pressed camera")
                            })
                            {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                                    .foregroundColor(Color.gray)
                                    .overlay(content: {
                                        Circle()
                                            .stroke(.black, lineWidth: 1)
                                    })
                                    .padding()
                            }
                            
                            Spacer()
                            
                            VStack {
                                Button(action: {
//                                    print("Pause was clicked")
//                                    isPaused = true
//                                    inRunningMode = false
                                }) {
                                    Circle()
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(Color.yellow)
                                        .overlay(content: {
                                            Circle()
                                                .stroke(.black, lineWidth: 2)
                                        })
                                        .overlay {
                                            Text("Pause")
                                                .foregroundColor(Color.black)
                                                .fontWeight(.bold)
                                                .font(.title)
                                        }
                                        .padding()
                                }
                                .simultaneousGesture(LongPressGesture(minimumDuration: 3).onEnded { _ in
                                    print("Secret Long Press Action!")
                                    inRunningMode = false
                                })
                                .simultaneousGesture(TapGesture().onEnded {
                                    print("Pause was clicked")
                                    isPaused = true
                                })
                            }
                            Spacer()
                            
                            // this will locate the user based on the phone gps
                            Button(action: {
                                print("location clicked")
                                region.checkLocationAuthorization()
                            }) {
                                Image(systemName: "location.circle.fill")
                                    .resizable()
                                    .frame(width: iconHeightAndWidth, height: iconHeightAndWidth)
                                    .foregroundColor(Color.blue)
                                    .overlay(content: {
                                        Circle()
                                            .stroke(.black, lineWidth: 1)
                                    })
                                    .padding()
                                //                                            .border(Color.blue, width: 1)
                            }
                        }
                        }
                    }
                }
            }
                
            }
        }
}
