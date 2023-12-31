//
//  AudioDetailView.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import SwiftUI
import Combine

struct AudioDetailView: View {
    
    @ObservedObject var viewModel: AudioDetailViewModel
    
    var body: some View {
        ZStack {
            Color(red: 255 / 255.0, green: 248 / 255.0, blue: 243 / 255.0)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                AsyncImageView(currentUrlString: viewModel.posterImagePath)
                
                Text("KEY POINT \(viewModel.currentIndex + 1) OF \(viewModel.audioIds.count)")
                    .font(.callout)
                    .padding(.vertical, 2)
                    .foregroundColor(.gray)
                
                Text(viewModel.currentTitle)
                    .font(.callout)
                    .padding(.vertical, 2)
                
                HStack {
                    Text(formatTime(viewModel.currentTime))
                    CustomSlider(value: $viewModel.currentTime, range: 0...viewModel.duration, onEditingChanged: sliderEditingChanged)
                    
                    Text(formatTime(viewModel.duration))
                }
                .padding(.vertical, 10)
                
                Button("Speed \(formatSpeed(viewModel.playbackRate))") {
                    viewModel.changePlaybackRate()
                }
                .buttonStyle(SpeedButtonStyle())
                .padding(.bottom, 20)
                
                HStack(spacing: 20) {
                    Button(action: viewModel.previousTrack) {
                        Image(systemName: "backward.end.fill")
                    }
                    .foregroundColor(viewModel.hasPreviousTrack ? .black : .gray)
                    .disabled(!viewModel.hasPreviousTrack)
                    
                    Button(action: { viewModel.rewindBy(seconds: -5) }) {
                        Image(systemName: "gobackward.5")
                    }
                    .foregroundColor(.black)
                    
                    Button(action: viewModel.playPause) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .foregroundColor(.black)
                    
                    Button(action: { viewModel.rewindBy(seconds: 10) }) {
                        Image(systemName: "goforward.10")
                    }
                    .foregroundColor(.black)
                    
                    Button(action: viewModel.nextTrack) {
                        Image(systemName: "forward.end.fill")
                    }
                    .foregroundColor(viewModel.hasNextTrack ? .black : .gray)
                    .disabled(!viewModel.hasNextTrack)
                }
                .font(.title)
                .padding(.bottom, 20)
                Spacer(minLength: UIScreen.main.bounds.height * 0.1)
            }
            .padding()
            .onAppear {
                self.viewModel.initializeSubscribers()
            }
            .onDisappear {
                self.viewModel.stop()
            }
        }
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if !editingStarted { viewModel.seekTo(viewModel.currentTime) }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let time = Int(seconds)
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    private func formatSpeed(_ rate: Float) -> String {
        if rate.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", rate)
        } else {
            return String(format: "%.1f", rate)
        }
    }
    
}
