//
//  RunView.swift
//  trun
//
//  Created by Sabath  Rodriguez on 12/7/24.
//

import SwiftUI

struct RunView: View {
    @Binding var selectedRun: Pace?
    @Binding var runTypeDict: [Pace: Double]
    @Binding var runningMenuHeight: PresentationDetent
    
    
    var body: some View {
        VStack {
            // running info
            RunInfoView(selectedRun: $selectedRun, runTypeDict: $runTypeDict, runningMenuHeight: $runningMenuHeight)
            
            // this allows the user to select what to display as far as running information
            RunListView(selectedRun: $selectedRun, runTypeDict: $runTypeDict)
        }
    }
}
