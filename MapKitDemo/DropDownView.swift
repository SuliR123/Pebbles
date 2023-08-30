//
//  DropDownView.swift
//  MapKitDemo
//
//  Created by Suli Rashidzada on 8/29/23.
//

import SwiftUI

// Drop down for filter options on the map
struct DropDownView: View {
    
    // Display drop down menu or not
    @State private var displayOptions = false
    
    // reference to how the locations are being filtered 
    @EnvironmentObject var viewModel : ContentViewModel
    
    var body: some View {
        VStack {
            // Button that enables drop down of filter buttons 
            HStack {
                Button(
                    action: {
                        displayOptions.toggle()
                    },
                    label: {
                        Text("Filter")
                            .bold()
                            .frame(width: 125, height: 50, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    })
                Spacer()
            }
            
            // stack of buttons for the drop down
            if displayOptions {
                VStack {
                    FilterButtonView(action : {
                        viewModel.setFilterType(type: .normal)
                    }, displayText: "none")
                    
                    FilterButtonView(action : {
                        viewModel.setFilterType(type: .byOneDay)
                    }, displayText: "24 Hours")
                    
                    FilterButtonView(action : {
                        viewModel.setFilterType(type: .byTenSeconds)
                    }, displayText: "10 Seconds")
                }
            }
        }
    }
}

// Represents a button in the drop down that filters locations
struct FilterButtonView : View {
    
    var action : () -> Void
    var displayText : String
    
    init(action: @escaping () -> Void, displayText: String) {
        self.action = action
        self.displayText = displayText
    }
    
    var body : some View {
        HStack {
            // creates a button with specified action
            Button(
                action: action,
                label: {
                    Text(displayText)
                        .bold()
                        .frame(width: 90, height: 50, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            )
            Spacer()
        }
    }
}

#Preview {
    DropDownView()
}


