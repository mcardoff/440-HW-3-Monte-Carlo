//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Terry on 12/31/20.
//

//   _ 1
//  /      - x
//  |    e     dx
// _/  0

import SwiftUI

struct ContentView: View {
    
    @State var integral = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var radius = 1.0
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var integralString = "0.0"
    
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var monteCarlo = MonteCarloCircle(withData: true)
    
    //Setup the GUI View
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Total Guesses", text: $totalGuessString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Integral")
                        .font(.callout)
                        .bold()
                    TextField("# π", text: $integralString)
                        .padding()
                }
                
                Button("Cycle Calculation", action: { Task.init{await self.calculateIntegral()} })
                    .padding()
                    .disabled(monteCarlo.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(monteCarlo.enableButton == false)
                
                if (!monteCarlo.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
            //DrawingField
            
            
            drawingView(redLayer:$monteCarlo.insideData, blueLayer: $monteCarlo.outsideData)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
            // Stop the window shrinking to zero.
            Spacer()
            
        }
    }
    
    func calculateIntegral() async {
        
        monteCarlo.setButtonEnable(state: false)
        monteCarlo.guesses = Int(guessString)!
        monteCarlo.radius = radius
        monteCarlo.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarlo.calculateIntegral()
        
        totalGuessString = monteCarlo.totalGuessesString
        
        integral = monteCarlo.integral
        integralString = monteCarlo.integralString
        
        monteCarlo.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        integralString =  ""
        monteCarlo.totalGuesses = 0
        monteCarlo.totalIntegral = 0.0
        monteCarlo.insideData = []
        monteCarlo.outsideData = []
        monteCarlo.firstTimeThroughLoop = true
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
