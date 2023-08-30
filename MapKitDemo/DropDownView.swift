//
//  DropDownView.swift
//  MapKitDemo
//
//  Created by Suli Rashidzada on 8/29/23.
//

import SwiftUI

// Drop down for filter options on the map
struct DropDownView: View {
    
    @State private var displayOptions = false
    
    @EnvironmentObject var viewModel : ContentViewModel
    
    var body: some View {
        VStack {
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

struct FilterButtonView : View {
    
    var action : () -> Void
    var displayText : String
    
    init(action: @escaping () -> Void, displayText: String) {
        self.action = action
        self.displayText = displayText
    }
    
    var body : some View {
        HStack {
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


