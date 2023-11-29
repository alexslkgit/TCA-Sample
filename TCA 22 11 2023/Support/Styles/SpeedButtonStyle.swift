//
//  SpeedButtonStyle.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 30.11.2023.
//

import SwiftUI

struct SpeedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 2)
            )
    }
}
