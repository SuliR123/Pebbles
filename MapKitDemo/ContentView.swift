//
//  ContentView.swift
//  MapKitDemo
//
//  Created by Suli Rashidzada on 8/13/23.
//

// IDEAS!!!
// display stats such as total distance traveled
// percentage of the world that you have explored
// let the user create markers which they can store photos
// descriptions of the the location, store the date the location was
// "discovered" by the user 
// timeline function to display where the user has traveled in chronilogical order (animates the path the person has taken since downloading the app)
// Create button that allows you to display all of your movement within a certain time period for example all movements within the last day


import SwiftUI
import MapKit

struct ContentView: View {
    
    // checks if we are displaying side menu or not
    @State private var isShowing = false
    
    // tracks all locations and filtering
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            if isShowing {
                SideMenuView(isShowing: $isShowing)
            }
            
            // displays map to user
            // conditional renders for when the side menu view is open
            HomeView()
                .cornerRadius(isShowing ? 20 : 0)
                .offset(x : isShowing ? 150 : 0, y: 0)
  
                .ignoresSafeArea()
                .overlay(alignment: .topLeading) {
                    Button(
                        action: {
                            withAnimation(.spring()) {
                                isShowing.toggle()
                            }
                        },
                        label: {
                            // Stops rendering menu icon when side bar is open
                            if !isShowing {
                                Image("MenuIcon")
                                    .bold()
                                    .frame(width: 60, height: 45, alignment: .center)
                            }
                        }
                    )
                }
        }
        .environmentObject(viewModel)
    }
        
}

#Preview {
    ContentView()
}

struct HomeView : View {
    
    // gets reference to environments instance of the users location
    @EnvironmentObject var viewModel : ContentViewModel
    
    @Namespace var mapScope
    
    // displays map to user
    var body : some View {
        VStack {
            Map(scope: mapScope) {
                UserAnnotation()
                MapPolyline(coordinates: viewModel.displayCords)
                    .stroke(.blue.opacity(0.5), lineWidth: 40)
            }
            .overlay(alignment: .bottomTrailing) {
                MapUserLocationButton(scope: mapScope)
                    .frame(width: 60, height: 90)
                    .buttonBorderShape(.circle)
            }
            .onAppear {
                // asks the users permission to use their location
                viewModel.checkLocationServices()
            }
        }
        .mapScope(mapScope)
    }
}
