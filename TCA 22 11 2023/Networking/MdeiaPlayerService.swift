//
//  MdeiaPlayerService.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 23.12.2023.
//

import Foundation
import ComposableArchitecture
import AVFoundation

class MdeiaPlayerService: NSObject {
    
    var audioPlayer = AVPlayer()
    
    func playPause(state: inout AudioDetailFeature.State) {
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
            state.isPlaying = false
        } else {
            audioPlayer.play()
            state.isPlaying = true
        }
    }
    
    func seek(to time: Double) {
        audioPlayer.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func changePlaybackRate(state: inout AudioDetailFeature.State) {
        state.playbackRate = (state.playbackRate == 1.0) ? 1.5 : 1.0
        audioPlayer.rate = state.playbackRate
    }
    
    func loadItem(url: URL, state: inout AudioDetailFeature.State) {
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
//        playerItem.addObserver(self,
//                               forKeyPath: "status",
//                               options: [.new, .initial],
//                               context: nil)
        self.audioPlayer.play()
        state.isPlaying = true

//        return .run(operation: { send in
//            await send(.audioIsreadyToPlay)
//        })
    }
    
    func stop() {
        self.audioPlayer.pause()
    }
    
    func rewind(by seconds: Double, state: inout AudioDetailFeature.State) {
        guard let duration = audioPlayer.currentItem?.duration.seconds, !duration.isNaN else {
            return
        }
        
        let newTime = CMTimeGetSeconds(audioPlayer.currentTime()) + seconds
        if newTime >= 0 && newTime <= duration {
            audioPlayer.seek(to: CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
    }
    
    func updateDuration(state: inout AudioDetailFeature.State) {
        if let duration = audioPlayer.currentItem?.duration.seconds, !duration.isNaN {
            state.duration = duration
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            print(keyPath)
//            switch playerItem.status {
//            case .readyToPlay:
//                // Обробка стану readyToPlay
//            case .failed:
//                // Обробка помилки
//            default:
//                break
//            }
        }
    }
}

private enum MdeiaPlayerServiceKey: DependencyKey {
    
    static let liveValue = MdeiaPlayerService()
}

extension DependencyValues {
    
    var mediaPlayer: MdeiaPlayerService {
        get { self[MdeiaPlayerServiceKey.self] }
        set { self[MdeiaPlayerServiceKey.self] = newValue }
    }
}
