//
//  ContentView.swift
//  pomodoro
//
//  Created by Adit Chakraborty on 15/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var restTime = 10
    @State private var workTime = 30
    @State private var timeRemaining: TimeInterval = 30
    @State private var timer: Timer?
    @State private var isRunning: Bool = false
    @State private var onBreak: Bool = true
    @State private var score = 0
    
    let formatter: NumberFormatter = {
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         return formatter
     }()
    
    var timerColor: Color {
        if onBreak {
            return .cyan
        } else {
            return.orange
        }
    }
    
    var status: String {
        if onBreak {
            return "Get some rest!"
        } else {
            return "Get working!"
        }
    }
        
    func GetTimeFmt() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func StopTimer() {
        onBreak.toggle()
        isRunning = false
        timer?.invalidate()
        
        if onBreak {
            timeRemaining = TimeInterval(restTime)
        } else {
            timeRemaining = TimeInterval(workTime)
        }
    }
    
    func StartTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                StopTimer()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack {
                    Text("I want to work for")
                    Spacer()
                    TextField("I want to work for", value: $workTime, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
             
                HStack {
                    Text("I want to rest for")
                    Spacer()
                    TextField("I want to rest for", value: $restTime, formatter: formatter)
                        .textFieldStyle(.roundedBorder)
                }
                
                Text(status)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                    Circle()
                        .trim(from: 0, to: CGFloat(1 - timeRemaining / Double(workTime)))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(timerColor)
                        .rotationEffect(.degrees(-90))
                    
                    Text(GetTimeFmt())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                }
                .padding()
                .frame(maxWidth: 500)
                
                HStack {
                    Button(isRunning ? "Stop" : "Start") {
                        isRunning.toggle()
                        
                        if isRunning {
                            StartTimer()
                        } else {
                            StopTimer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .frame(width: 100, height: 100)
                    .font(.title)
                }
            }
            .padding(.horizontal, 40)
            .navigationTitle("Pomodoro Timer")
        }
    }
}

#Preview {
    ContentView()
}
