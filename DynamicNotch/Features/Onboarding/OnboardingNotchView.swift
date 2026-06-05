//
//  OnboardingNotchView.swift
//  DynamicNotch
//
//  Created by Евгений Петрукович on 4/7/26.
//

import SwiftUI

struct OnboardingNotchView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.isDynamicIsland) private var isDynamicIsland
    
    let step: OnboardingSteps
    let onStepChange: (OnboardingSteps) -> Void
    let onFinish: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            stepContent
            buttons
        }
        .animation(.spring(duration: 0.4), value: step)
        .padding(.horizontal, isDynamicIsland ? 12 : 35)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .first:
            OnboardingNotchFirstStepView()
        case .second:
            OnboardingNotchSecondStepView()
        case .third:
            OnboardingNotchThirdStepView()
        case .fourth:
            OnboardingNotchFourthStepView()
        }
    }
    
    @ViewBuilder
    private var buttons: some View {
        switch step {
        case .first:
            HStack {
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    Text(verbatim: "Quit")
                        .font(Font.system(.footnote, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: .red.opacity(0.35)))
                
                Spacer()
                
                Button(action: {
                    onStepChange(.second)
                }) {
                    Text(verbatim: "Continue")
                        .font(Font.system(.footnote, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: Color.accentColor.opacity(0.6)))
            }
            
        case .second:
            HStack {
                Button(action: {
                    guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security") else {
                        return
                    }
                    openURL(url)
                    
                }) {
                    Text(verbatim: "Open Settings")
                        .font(Font.system(.footnote, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: .gray.opacity(0.4)))
                
                Spacer()
                
                Button(action: {
                    onStepChange(.third)
                }) {
                    Text(verbatim: "Continue")
                        .font(Font.system(.footnote, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: Color.accentColor.opacity(0.6)))
            }
            
        case .third:
            HStack {
                Spacer()
                
                Button(action: {
                    onStepChange(.fourth)
                }) {
                    Text(verbatim: "Continue")
                        .font(Font.system(.footnote, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: Color.accentColor.opacity(0.6)))
            }

        case .fourth:
            HStack {
                Spacer()

                Button(action: {
                    onFinish()
                }) {
                    Text(verbatim: "Get Started")
                        .font(Font.system(.footnote, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PrimaryButtonStyle(height: 35, backgroundColor: Color.accentColor.opacity(0.8)))
            }
        }
    }
}
