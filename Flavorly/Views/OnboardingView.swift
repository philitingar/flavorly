//
//  OnboardingView.swift
//  Flavorly
//
//  Created by Timea Bartha on 24/1/24.
//

import SwiftUI

struct OnboardingView: View {
    var doneFunction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("Features and notice:")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .padding()
            Text("Make finding your recipes a breeze by adding tags like vegan, dairy-free, Christmas, cake, and personal ones like grandma. With tags, you can easily search for exactly what you want, like those special recipes from your grandma that are also vegan.")
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
            Text("Try this: Label your recipes with all the ingredients (carrot, eggs, flour, chicken, etc.) as tags. Then, when you're staring into the fridge wondering what to eat, just search for the ingredients you have. You'll instantly find recipes you can make with the stuff you already have! Easy and convenient.")
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
            Spacer()
            Spacer()
            
            Button {
                self.doneFunction()
            } label: {
                Text("I understand")
                    .font(.headline)
                    .padding(10)
                    .foregroundColor(.primary)
                    .background(.ultraThinMaterial)
                    .background(Color.backgroundGreen)
                    .cornerRadius(12)
                    .padding()
                
            }
            Spacer()
        }
        .padding()
        
    }
}

