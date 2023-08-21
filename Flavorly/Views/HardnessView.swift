//
//  HardnessView.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//
import SwiftUI

struct HardnessView: View {
    @Binding var hardness: Int
    
    var label = ""
    var maximumHardness = 10
    
    var offImage: Image?
    var onImage = Image(systemName: "circle.fill")
    var offColor = Color.gray
    var onColor = Color.orange
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumHardness + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > hardness ? offColor : onColor)
                    .onTapGesture {
                        hardness = number
                    }
            }
        }
    }
    func image(for number: Int) -> Image {
        if number > hardness {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct HardnessView_Previews: PreviewProvider {
    static var previews: some View {
        HardnessView(hardness: .constant(4))
    }
}
