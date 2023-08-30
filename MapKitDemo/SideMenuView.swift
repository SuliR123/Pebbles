//
//  SideMenuView.swift
//  MapKitDemo
//
//  Created by Suli Rashidzada on 8/27/23.
//

import SwiftUI

// represents the side menu that is hidden at start of program
struct SideMenuView: View {
    @Binding var isShowing : Bool
        
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .teal ,.green]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            VStack(alignment: .leading) {
                // Button to close the side menu
                Button(action: {
                    withAnimation(.spring()) {
                        isShowing.toggle()
                    }
                },
                    label: {
                        Image(systemName: "xmark")
                        .frame(width: 44, height: 44)
                        .foregroundColor(.black)
                        .scaleEffect(1.5)
                        
                    }
                )
                
                // Drop down list of filter buttons
                DropDownView()
                
                // Stats drop down
                // Settings? 
                Spacer()
            }
            
        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
