//
//  ContentView.swift
//  pomodoro
//
//  Created by Adit Chakraborty on 15/06/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("restTime") private var restTime = 10
    @AppStorage("workTIme") private var workTime = 30
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
    
    var timeToUse: Int {
        if onBreak {
            return restTime * 60
        } else {
            return workTime * 60    
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
        
        timeRemaining = TimeInterval(timeToUse)
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
    
    let bgColor = Color("background")
    
    var body: some View {
        NavigationView {
            ZStack {
                if onBreak {
                    Color.indigo.edgesIgnoringSafeArea(.all)
                } else {
                    Color.orange.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                
                VStack(alignment: .center) {
                    Text(status)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                        Circle()
                            .trim(from: 0, to: CGFloat(1 - timeRemaining / Double(timeToUse)))
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
                        .tint(onBreak ? .blue : .brown)
                        .buttonBorderShape(.capsule)
                        .frame(width: 100, height: 100)
                        .font(.title)
                    }
                }
                .padding(.horizontal, 40)
                .navigationTitle("Pomodoro Timer")
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}
