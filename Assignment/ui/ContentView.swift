//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path
    @State var searchText: String = " "
    
    var filteredList: [DeviceData]{
        return viewModel.data?.filter{ $0.name.localizedCaseInsensitiveContains(searchText) } ?? []
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !filteredList.isEmpty {
                    DevicesList(devices: filteredList) { selectedComputer in
                        viewModel.navigateToDetail(navigateDetail: selectedComputer)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                path.append(navigate!)
            })
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .task {
                viewModel.fetchAPI()
            }
            .searchable(text: $searchText)
        }
    }
}
