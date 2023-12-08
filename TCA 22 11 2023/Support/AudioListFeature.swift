//
//  AudioListFeature.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 05.12.2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AudioListFeature {
    
    struct State: Equatable {
        
        var audioItemsResult: [AudioResult] = []
        var isLoading = false
        
        static func == (lhs: AudioListFeature.State, rhs: AudioListFeature.State) -> Bool {
            lhs.isLoading == rhs.isLoading &&
            lhs.audioItemsResult.count == rhs.audioItemsResult.count
        }
    }
    
    enum Action {
        case onAppear
        case audioListLoaded(Result<[AudioResult], Error>)
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let result = try await APIService().fetchAudioList()
                        await send(.audioListLoaded(.success(result)))
                    } catch {
                        await send(.audioListLoaded(.failure(error)))
                    }
                }
                
            case .audioListLoaded(let result):
                state.isLoading = false
                switch result {
                case .success(let audioItems):
                    state.audioItemsResult = audioItems
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }
    }
}

