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
            
            let audioItems = viewStore.state.audioItemsResult
            
            NavigationView {
                List(audioItems) { audioItem in
                    let idsList = audioItems.map { $0.id }
                    let currentIndex = idsList.firstIndex(of: audioItem.id) ?? 0
                    let store = Store(
                        initialState: AudioDetailFeature.State(
                            audioIds: idsList,
                            currentIndex: currentIndex
                        )) {
                            AudioDetailFeature()
                        }
                    
                    NavigationLink(destination: AudioDetailView(
                        store: store)) {
                            Text(audioItem.name ?? "No name")
                        }
                }
            }.onAppear {
                viewStore.send(.onAppear)
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
