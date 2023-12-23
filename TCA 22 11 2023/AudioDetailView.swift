//
//  AudioDetailView.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation
import Combine

struct AudioDetailView: View {
    
    let store: StoreOf<AudioDetailFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack {
                Color(red: 255 / 255.0, green: 248 / 255.0, blue: 243 / 255.0)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    AsyncImageView(currentUrlString: viewStore.posterImagePath)
                    
                    Text("KEY POINT \(viewStore.currentIndex + 1) OF \(viewStore.audioIds.count)")
                        .font(.callout)
                        .padding(.vertical, 2)
                        .foregroundColor(.gray)
                    
                    Text(viewStore.currentTitle)
                        .font(.callout)
                        .padding(.vertical, 2)
                    
                    HStack {
                        Text(formatTime(viewStore.currentTime))
                        
                        Slider(value: Binding(get: { viewStore.currentTime },
                                              set: { value in
                            print("Sheeeet")
                            viewStore.send(.sliderChanged(value))
                        }), in: 0...viewStore.duration)
                        
                        Text(formatTime(viewStore.duration))
                    }
                    .padding(.vertical, 10)
                    
                    Button("Speed \(formatSpeed(viewStore.playbackRate))") {
                        viewStore.send(.changePlaybackRate)
                    }
                    .buttonStyle(SpeedButtonStyle())
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            viewStore.send(.previousTrack)
                        }) {
                            Image(systemName: "backward.end.fill")
                        }
                        .foregroundColor(viewStore.state.hasPreviousTrack ? .black : .gray)
                        .disabled(!viewStore.state.hasPreviousTrack)
                        
                        Button(action: {
                            viewStore.send(.rewind(-5))
                        }) {
                            Image(systemName: "gobackward.5")
                        }
                        .foregroundColor(.black)
                        
                        Button(action: {
                            viewStore.send(.playPause)
                        }) {
                            Image(systemName: viewStore.state.isPlaying ? "pause.fill" : "play.fill")
                        }
                        .foregroundColor(.black)
                        
                        Button(action: {
                            viewStore.send(.rewind(10))
                        }) {
                            Image(systemName: "goforward.10")
                        }
                        .foregroundColor(.black)
                        
                        Button(action: {
                            viewStore.send(.nextTrack)
                        }) {
                            Image(systemName: "forward.end.fill")
                        }
                        .foregroundColor(viewStore.state.hasNextTrack ? .black : .gray)
                        .disabled(!viewStore.state.hasNextTrack)
                    }.onAppear {
                        viewStore.send(.onAppear)
                    }.onDisappear {
                        viewStore.send(.onDisappear)
                    }
                    .font(.title)
                    .padding(.bottom, 20)
                    Spacer(minLength: UIScreen.main.bounds.height * 0.1)
                }
                .padding()
            }
        }
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
