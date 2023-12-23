//
//  AudioDetailFeature.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 07.12.2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AudioDetailFeature {
    
    @Dependency(\.mediaPlayer) var mediaPlayer
    
    struct State: Equatable {
        
        var audioIds: [Int]
        var currentIndex: Int
        var currentTime: Double = 0
        var duration: Double = 0
        var playbackRate: Float = 1.0
        var isPlaying = false
        var currentTitle = ""
        var posterImagePath = ""
        var hasPreviousTrack: Bool { currentIndex - 1 >= 0 }
        var hasNextTrack: Bool { currentIndex + 1 < audioIds.count }
        var audioURL = URL(string: "")
        
        var currentAudioId: Int = 0
        
        static func == (lhs: AudioDetailFeature.State, rhs: AudioDetailFeature.State) -> Bool {
            lhs.audioIds == rhs.audioIds &&
            lhs.currentIndex == rhs.currentIndex &&
            lhs.currentTime == rhs.currentTime &&
            lhs.duration == rhs.duration &&
            lhs.playbackRate == rhs.playbackRate &&
            lhs.isPlaying == rhs.isPlaying &&
            lhs.currentTitle == rhs.currentTitle &&
            lhs.posterImagePath == rhs.posterImagePath &&
            lhs.hasPreviousTrack == rhs.hasPreviousTrack &&
            lhs.audioURL == rhs.audioURL &&
            lhs.currentAudioId == rhs.currentAudioId
        }
    }
    
    enum Action {
        case onAppear
        case onDisappear
        case sliderChanged(Double)
        case updateCurrentTime(Double)
        case playPause
        case rewind(Double)
        case changePlaybackRate
        case nextTrack
        case previousTrack
        case audioLoaded(Result<AudiofileDetails, Error>)
        case audioIsreadyToPlay
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            case .onAppear:
                let currentAudioId = state.audioIds[state.currentIndex]
                state.currentAudioId = currentAudioId
                return .run { send in
                    let token = "yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI"
                    let urlString = "https://freesound.org/apiv2/sounds/\(currentAudioId)/?token=\(token)"
                    guard let url = URL(string: urlString) else { throw URLError(.badURL) }
                    
                    let (data, response) = try await URLSession.shared.data(from: url)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    
                    let decoder = JSONDecoder()
                    let dataR = try decoder.decode(AudiofileDetails.self, from: data)
                    await send(.audioLoaded(.success(dataR)))
                }
            case .onDisappear:
                self.mediaPlayer.stop()
                return .none
                
            case .sliderChanged(let newTime):
                self.mediaPlayer.seek(to: newTime)
                return .none
                
            case .playPause:
                mediaPlayer.playPause(state: &state)
                return .none
                
            case .rewind(let seconds):
                mediaPlayer.rewind(by: seconds, state: &state)
                return .none
                
            case .changePlaybackRate:
                self.mediaPlayer.changePlaybackRate(state: &state)
                return .none
                
            case .nextTrack:
                if state.hasNextTrack {
                    state.currentIndex += 1
                    state.currentAudioId = state.audioIds[state.currentIndex]
                }
                return .run(operation: { send in
                    await send(.onAppear)
                })
                
            case .previousTrack:
                if state.hasPreviousTrack {
                    state.currentIndex -= 1
                    state.currentAudioId = state.audioIds[state.currentIndex]
                }
                return .run(operation: { send in
                    await send(.onAppear)
                })
                
            case .audioLoaded(let result):
                
                switch result {
                case .success(let audioDetails):
                    state.currentTitle = audioDetails.name ?? ""
                    state.posterImagePath = audioDetails.images?.spectralBWL ?? ""
                    guard let url = URL(string: audioDetails.previews?.previewHqMp3 ?? "") else { return .none }
                    
                    self.mediaPlayer.loadItem(url: url, state: &state)
                    return .run(operation: { send in
                        await send(.audioIsreadyToPlay)
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return .none
            case .updateCurrentTime(let newTime):
                state.currentTime = newTime
                return .none
            case .audioIsreadyToPlay:
                self.mediaPlayer.updateDuration(state: &state)
                return .none
            }
        }
    }
}
