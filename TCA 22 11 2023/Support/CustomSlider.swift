//
//  CustomSlider.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 01.12.2023.
//

import SwiftUI

struct CustomSlider: View {
    
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: (Bool) -> Void
    
    var trackHeight: CGFloat = 5
    var thumbSize: CGFloat = 15
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(height: trackHeight)
                    if range.upperBound > range.lowerBound {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: max(CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, 0), height: trackHeight)
                    }
                    
                    let thumbOffset = (thumbSize / 2) + (geometry.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)))
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(x: thumbOffset - thumbSize / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let sliderPosition = gesture.location.x / geometry.size.width
                                    let newValue = range.lowerBound + (sliderPosition * (range.upperBound - range.lowerBound))
                                    self.value = min(max(newValue, range.lowerBound), range.upperBound)
                                    onEditingChanged(true)
                                }
                                .onEnded { _ in
                                    onEditingChanged(false)
                                }
                        )
                }
                Spacer()
            }
        }
        .frame(height: thumbSize + 20)
    }
}
