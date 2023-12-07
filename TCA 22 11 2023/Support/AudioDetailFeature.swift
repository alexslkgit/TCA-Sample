//
//  AudioDetailFeature.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 07.12.2023.
//

import Foundation
import ComposableArchitecture
import AVFoundation

@Reducer
struct AudioDetailFeature {
    
    var audioPlayer = AVPlayer()
    
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
    }
    enum Action {
        case onAppear
        case onDisappear
        case sliderChanged(Double)
        case playPause
        case rewind(Double)
        case changePlaybackRate
        case nextTrack
        case previousTrack
        case audioLoaded(Result<AudiofileDetails, Error>)
    }
    
    struct Environment {
        var audioPlayer: AVPlayer?
        var apiService: APIService
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
                self.audioPlayer.pause()
                return .none
                
            case .sliderChanged(let newTime):
                self.audioPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
                return .none
                
            case .playPause:
                if self.audioPlayer.timeControlStatus == .playing {
                    self.audioPlayer.pause()
                    state.isPlaying = false
                } else {
                    self.audioPlayer.play()
                    state.isPlaying = true
                }
                return .none
                
            case .rewind(let seconds):
                guard let duration = self.audioPlayer.currentItem?.duration.seconds,
                      !duration.isNaN else { return .none }
                
                let newTime = CMTimeGetSeconds(self.audioPlayer.currentTime()) + seconds
                if newTime >= 0 && newTime <= duration {
                    self.audioPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
                }
                return .none
                
            case .changePlaybackRate:
                state.playbackRate = (state.playbackRate == 1.0) ? 1.5 : 1.0
                self.audioPlayer.rate = state.playbackRate
                return .none
                
            case .nextTrack:
                
                return .none
                
            case .previousTrack:
                return .none
                
            case .audioLoaded(let result):
                
                switch result {
                case .success(let audioDetails):
                    state.currentTitle = audioDetails.name ?? ""
                    state.posterImagePath = audioDetails.images?.spectralBWL ?? ""
                    if let url = URL(string: audioDetails.previews?.previewHqMp3 ?? "") {
                        state.audioURL = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                return .none
            }
            
        }
    }
    
}

/*
 
 Reduce { state, action in
 
 switch action {
 case .onAppear:
 let currentAudioId = state.audioIds[state.currentIndex]
 state.currentAudioId = currentAudioId
 return .run { send in
 
 guard let url = URL(string: "https://freesound.org/apiv2/sounds/\(currentAudioId)/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI") else {
 throw URLError(.badURL)
 }
 
 let (data, response) = try await URLSession.shared.data(from: url)
 guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
 throw URLError(.badServerResponse)
 }
 
 let decoder = JSONDecoder()
 let dataR = try decoder.decode(AudiofileDetails.self, from: data)
 await send(.audioLoaded(.success(dataR)))
 }
 case .onDisappear:
 self.audioPlayer.pause()
 case .sliderChanged(let newTime):
 self.audioPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
 case .playPause:
 if self.audioPlayer.timeControlStatus == .playing {
 self.audioPlayer.pause()
 state.isPlaying = false
 } else {
 self.audioPlayer.play()
 state.isPlaying = true
 }
 return .none
 case .rewind(let seconds):
 guard let duration = self.audioPlayer.currentItem?.duration.seconds,
 !duration.isNaN else { return .none }
 
 let newTime = CMTimeGetSeconds(self.audioPlayer.currentTime()) + seconds
 if newTime >= 0 && newTime <= duration {
 self.audioPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
 }
 return .none
 case .changePlaybackRate:
 state.playbackRate = (state.playbackRate == 1.0) ? 1.5 : 1.0
 self.audioPlayer.rate = state.playbackRate
 return .none
 case .nextTrack:
 if state.hasNextTrack {
 state.currentIndex += 1
 state.currentAudioId = state.audioIds[state.currentIndex]
 if let audioId = state.currentAudioId {
 let response = try await APIService().fetchAudioDetails(audioId: audioId)
 state.currentTitle = response.name ?? ""
 state.posterImagePath = response.images?.spectralBWL ?? ""
 if let url = URL(string: response.previews?.previewHqMp3 ?? "") {
 state.audioPlayer = AVPlayer(url: url)
 state.audioPlayer?.play()
 }
 }
 }
 return .none
 case .previousTrack:
 if state.hasPreviousTrack {
 state.currentIndex -= 1
 state.currentAudioId = state.audioIds[state.currentIndex]
 if let audioId = state.currentAudioId {
 let response = try await APIService().fetchAudioDetails(audioId: audioId)
 state.currentTitle = response.name ?? ""
 state.posterImagePath = response.images?.spectralBWL ?? ""
 if let url = URL(string: response.previews?.previewHqMp3 ?? "") {
 state.audioPlayer = AVPlayer(url: url)
 state.audioPlayer?.play()
 }
 }
 }
 return .none
 case .audioLoaded(let result):
 switch result {
 case .success(let audioDetails):
 state.currentTitle = audioDetails.name ?? ""
 state.posterImagePath = audioDetails.images?.spectralBWL ?? ""
 if let url = URL(string: audioDetails.previews?.previewHqMp3 ?? "") {
 state.audioPlayer = AVPlayer(url: url)
 state.audioPlayer?.play()
 }
 case .failure(let error):
 // Обробка помилки
 print(error.localizedDescription)
 }
 return .none
 }
 }
 }
 
 */
