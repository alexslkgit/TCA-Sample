//
//  AudioListView.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import SwiftUI
import Alamofire
import ComposableArchitecture

struct AudioListView: View {
    
    let store: StoreOf<AudioListFeature>
    @State private var isLoading: Bool = true
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            switch viewStore.state.audioItemsResult {
                
            case .success(let audioItems):
                
                NavigationView {
                    
                    List(audioItems) { audioItem in
                        
                        let idsList = audioItems.map { $0.id }
                        let currentIndex = idsList.firstIndex(of: audioItem.id) ?? 0
                        
                        NavigationLink(destination: AudioDetailView(
                            store: Store(
                                initialState: AudioDetailFeature.State(
                                    audioIds: idsList,
                                    currentIndex: currentIndex
                                ),
                                reducer: AudioDetailFeature.reducer()))) {
                            Text(audioItem.name ?? "No name")
                        }
                    }
                }
            case .failure(_):
                Text("ERROR")
            }
        }
    }
}

#Preview {
    AudioListView(
        store: Store(initialState: AudioListFeature.State()) {
            AudioListFeature()
        }
    )
}

/*
NavigationLink(destination: AudioDetailView(
    store: Store(initialState: AudioListFeature.State()) {
        AudioDetailFeature()
    }) {
    Text(audioItem.name ?? "No name")
})
*/
