//
//  StatisticsView.swift
//  PCrypto
//
//  Created by Logycent on 24/12/2024.
//

import SwiftUI

struct StatisticsView: View {
    let stat: StatisticsModel
    var body: some View {
        VStack {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0: 180)
                    )
                Text(stat.percentageChange?.asPercentage() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(stat.percentageChange ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    StatisticsView(stat: DeveloperPreview.instance.stat1)
    
    StatisticsView(stat: DeveloperPreview.instance.stat2)
}
