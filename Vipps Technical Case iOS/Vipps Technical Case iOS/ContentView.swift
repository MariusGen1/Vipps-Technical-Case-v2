//
//  ContentView.swift
//  Vipps Technical Case iOS
//
//  Created by Marius Genton on 10/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var dataManager = DataManager()

    @State private var selectedCountry = "Norway"
    
    var body: some View {
        VStack {
            // Title
            Text(dataManager.allCountries[selectedCountry] == nil ? "No country selected":dataManager.allCountries[selectedCountry]!.name)
                .fontWeight(.bold)
                .font(.system(.title3))
            
            
            // If no country has been looked up, display instructions
            if dataManager.allCountries[selectedCountry] == nil {
                BodyWithIcon(text: "Enter the name of a country in the text field to get its information", iconName: "info.circle")
            }
            
            
            // Otherwise, display information about the country
            else {
                // In here, we can force-unwrap the dataManager's "country" property, since we have already verified its existence.
                
                // Capital
                BodyWithIcon(text: "Capital: " + (dataManager.allCountries[selectedCountry]!.capital ?? "no capital listed"), iconName: "mappin.circle")
                
                // Alternative spellings count
                BodyWithIcon(text: String((dataManager.allCountries[selectedCountry]!.altSpellings ?? []).count) + " alternative spellings", iconName: "text.magnifyingglass")
                
            }
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(UIColor.systemGray6))
                    .frame(height: 50)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                        .foregroundColor(Color(UIColor.systemGray3))

                    if Array(dataManager.allCountries.keys) != [] {
                        Picker("Pick a country", selection: $selectedCountry) {
                            ForEach(Array(dataManager.allCountries.keys.sorted()), id: \.self) { name in
                                Text(name)
                                    .tag(name)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .pickerStyle(.menu)
                    }
                }
            }
            .padding()
            
            
            if dataManager.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
            
            
            // Information label: to inform the user about any errors
            if dataManager.error != nil {
                // An error occurred during the last request
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text(dataManager.error!) // Can be force-unwrapped because we know for sure that it is not nil
                }
                .foregroundColor(.red)
                .padding()
            }
        }
        .onAppear(perform: { Task { await dataManager.getDataForAllCountries() } })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
