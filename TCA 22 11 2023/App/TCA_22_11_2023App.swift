//
//  TCA_22_11_2023App.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_22_11_2023App: App {
    var body: some Scene {
        WindowGroup {
            AudioListView(
                store: Store(initialState: AudioListFeature.State()) {
                    AudioListFeature()
                }
            )
        }
    }
}
