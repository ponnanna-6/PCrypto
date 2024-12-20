//
//  CircleButtonAnimationView.swift
//  PCrypto
//
//  Created by Logycent on 20/12/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
        
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1: 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : Animation.easeIn(duration: 1.0))
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
}
