//
//  RunInfoView.swift
//  trun
//
//  Created by Sabath  Rodriguez on 12/7/24.
//

import SwiftUI
import SwiftData
import MapKit
import AVFoundation
import UIKit
import Photos

struct RunInfoView: View {
    @Binding var selectedRun: Pace?
    @Binding var runTypeDict: [Pace: Double]
    @Binding var runningMenuHeight: PresentationDetent
    @Binding var searchWasClicked: Bool

    @State var inRunningMode: Bool = false
    @State var isPaused: Bool = false
    @State private var isLongPressing = false
    @State var searchField: String = ""
    
    @StateObject var locationManager = LocationManager()
    
    @FocusState var isSearchFieldFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var region: UserLocation
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect() // 1-second interval
    @State private var counter = 0.0
    @State private var isTimerPaused: Bool = false
    
    var iconHeightAndWidth: CGFloat = 75
    
    let generator = UISelectionFeedbackGenerator()
    
    private let cancelTimer = 1.5
    
    @State private var isCameraAvailable = false
    @State private var isImagePickerPresented = false
            
    var body: some View {
        
        let twoDecimalPlaceRun = String(format: "%.2f", locationManager.convertToMiles())
        let twoDecimalPlaceRunArray = twoDecimalPlaceRun.split(separator: ".")
        let minute = Int(counter/60)
        let seconds = String(format: "%.2f", counter.truncatingRemainder(dividingBy: 60.0))
        let minPerMile = String(format: "%.2f", locationManager.convertToMiles() > 0 ? Double(minute)/locationManager.convertToMiles() : 0)
        
        HStack {
            if (runningMenuHeight == .height(100)) {
                if (selectedRun != nil) {
                    Text("Distance: \(locationManager.convertTofeet()) feet")
                        .font(.title2)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .bold()
                        .padding(.top, 30)
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
                            locationManager.distance = 0
                            locationManager.startTracking()
                            isTimerPaused = false
                            isPaused = false
                            counter = 0
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
                    VStack {

                        if (selectedRun != nil) {

                            VStack {
                                Text("Distance: \(twoDecimalPlaceRunArray[0]).\(twoDecimalPlaceRunArray[1]) mi")
                                Text("Time: \(minute):\(seconds)")
                                Text("min/mile: \(minPerMile)")
                            }
                            .font(.title2)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .bold()
                            .padding(.top, 30)
                        } else {
                            Text("Select a run type")
                            .padding()
                        }
                        HStack {

                        // button will allow user to search location
                        Button(action: {
                            isImagePickerPresented = true
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
                        .disabled(!isCameraAvailable)
                        .onAppear(perform: checkCameraAvailability)
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(sourceType: .camera) { image in
                                // Handle the captured image here (optional)
                                if let image = image {
                                    saveImageToPhotoLibrary(image: image)
                                }
                            }
                        }                        

                        Spacer()

                        VStack {
                            if (isPaused) {
                                Button(action: {}){
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
                                .simultaneousGesture(LongPressGesture(minimumDuration: cancelTimer).onEnded { _ in
                                    inRunningMode = false
                                    locationManager.stopTracking()
                                    isTimerPaused = true
                                    counter = 0
                                    generator.prepare()
                                    generator.selectionChanged()
                                })
                                .simultaneousGesture(TapGesture().onEnded {
                                    isPaused = false
                                    locationManager.startTracking()
                                    isTimerPaused = false
                                })
                            } else {
                                Button(action: {}) {
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
                                .simultaneousGesture(LongPressGesture(minimumDuration: cancelTimer).onEnded { _ in
                                inRunningMode = false
                                locationManager.stopTracking()
                                isTimerPaused = true
                                counter = 0
                                generator.prepare()
                                generator.selectionChanged()
                            })
                            .simultaneousGesture(TapGesture().onEnded {
                                isPaused = true
                                locationManager.pauseTracking()
                                isTimerPaused = true
                            })
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
                            }
                        }
                    }

                }
            }
        }
        .onReceive(timer) { _ in
            if (!isTimerPaused) {
                counter += 0.1
            }
        }
        .onAppear(perform: checkCameraAvailability)
    }
    
    private func checkCameraAvailability() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isCameraAvailable = granted
            }
        }
    }
    
    private func saveImageToPhotoLibrary(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}
