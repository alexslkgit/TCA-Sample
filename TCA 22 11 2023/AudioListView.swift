//
//  AudioListView.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import SwiftUI
import Alamofire

struct AudioListView: View {
    
    @State private var audioItems: [AudioResult] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationView {
            List(audioItems) { item in
                NavigationLink(destination: AudioDetailView(viewModel: AudioDetailViewModel(currentAudioId: item.id,
                                                                                            audioIds: audioItems.map { $0.id }))) {
                    Text(item.name ?? "No name")
                }
            }
            .navigationTitle("Audiobooks")
            .onAppear {
                loadAudioList()
            }
        }
    }
    
    private func loadAudioList() {
        APIService().fetchAudioList { result in
            switch result {
            case .success(let response):
                self.audioItems = response.results ?? []
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
}

#Preview {
    AudioListView()
}

// Image
// Key point label
// name of chapter
// start time / slider / end time
// speed button
// previous / back 5 sec / pause play / forvard 5 sec / next
// Image

