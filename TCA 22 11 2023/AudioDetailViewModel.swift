//
//  AudioDetailViewModel.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import AVFoundation
import Combine

class AudioDetailViewModel: ObservableObject {
    
    @Published var currentAudioId: Int
    @Published var audioIds: [Int]
    
    private var audioPlayer: AVPlayer?
    private var timeObserver: Any?
    
    @Published var currentIndex = 0
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var playbackRate: Float = 1.0
    @Published var isPlaying = false
    @Published var currentTitle = ""
    @Published var currentImage: String = ""
    
    init(currentAudioId: Int, audioIds: [Int]) {
        self.currentAudioId = currentAudioId
        self.audioIds = audioIds
        loadAndPlay(audioId: currentAudioId)
    }
    
    func loadAndPlay(audioId: Int) {
        
        APIService().fetchAudioDetails(audioId: audioId) { result in
            switch result {
            case .success(let response):
                if let audioURLString = response.previews?.previewHqMp3,
                    let url = URL(string: audioURLString) {
                    
                    let playerItem = AVPlayerItem(url: url)
                    self.audioPlayer = AVPlayer(playerItem: playerItem)
                    self.audioPlayer?.play()
                    self.setupTimeObserver()
                    self.isPlaying = true
                }
                if let url = response.images?.spectralBWL {
                    self.currentImage = url
                }
                if let currentTitle = response.name {
                    self.currentTitle = currentTitle
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupTimeObserver() {
        
        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
            if let duration = self?.audioPlayer?.currentItem?.duration.seconds, !duration.isNaN {
                self?.duration = duration
            }
        }
    }
    
    func playPause() {
        guard let player = audioPlayer else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    func rewindBy(seconds: Double) {
        guard let player = audioPlayer else { return }
        let newTime = CMTimeGetSeconds(player.currentTime()) + seconds
        if newTime < 0 || newTime > duration {
            return
        }
        seekTo(newTime)
    }
    
    func changePlaybackRate() {
        playbackRate = (playbackRate == 1.0) ? 1.5 : 1.0
        audioPlayer?.rate = playbackRate
    }
    
    func seekTo(_ time: Double) {
        audioPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func nextTrack() {
        // Логіка для переключення на наступний трек
    }
    
    func previousTrack() {
        // Логіка для переключення на попередній трек
    }
    
    deinit {
        if let observer = timeObserver {
            audioPlayer?.removeTimeObserver(observer)
        }
    }
}
