//
//  TagView.swift
//  Flavorly
//
//  Created by Timea Bartha on 18/1/24.
//

import SwiftUI
/*
struct TagView: View {
    @State var tags: [ThisTag] = rawtags.compactMap { tag -> ThisTag? in
        return .init(name: tag)
    }
    @State var text:String = ""
    
    var body: some View {
            VStack {
                ThisTagView(alignment: .center, spacing: 10) {
                    ForEach($tags) { $tag in
                        //MARK: New Toggle API
                        Button(tag.name)
                            .buttonStyle(.bordered)
                            .tint(.primary)
                    }
                }
                HStack {
                    //MARK: New API
                    //multi line textfield
                    TextField("Tag", text: $text,axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    //Line Limit
                    //If it exceeds then it will enable scrollView
                        .lineLimit(1...5)
                    
                    Button("Add") {
                        withAnimation(.spring()) {
                            tags.append(ThisTag(name: text))
                            text = ""
                        }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 4))
                    .tint(.green)
                    .disabled(text == "")
                }
               
            }
            .padding(15)
            .navigationTitle(Text("Layout"))
        }
}

#Preview {
    TagView()
}
 */
//MARK: Building Custom layout with the new layout API

    struct TagView: Layout {
        var alignment: Alignment = .center
        var spacing: CGFloat = 10
        
        init(alignment: Alignment, spacing: CGFloat) {
            self.alignment = alignment
            self.spacing = spacing
        }
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
            //Returning Default Proposal Size
            return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            //Note: Use Origin since Origin will start from Applied Padding from Parent View
            var origin = bounds.origin
            var maxWidth = bounds.width
            // this is where the tags start showing up on top left corner
            subviews.forEach { view in
                let viewSize = view.sizeThatFits(proposal)
                // checking is View is going over maxwidth
                if (origin.x + viewSize.width + spacing) > maxWidth {
                    //updating Origin for next element in vertical order
                    origin.y += (viewSize.height +  spacing)
                    //resetting horizontal axis
                    origin.x = bounds.origin.x
                    //next view
                    view.place(at: origin, proposal: proposal)
                    //Updating Origin for next View placemet
                    //Adding Spacing
                    origin.x += (viewSize.width + spacing)
                    
                } else {
                    view.place(at: origin, proposal: proposal)
                    //Updating Origin for next View placemet
                    //Adding Spacing
                    origin.x += (viewSize.width + spacing)
                }
                
            }
            
        }
        
    }

/*
// MARK: String Tags
var rawtags:[String] = ["christmas", "soup", "vegan", "sausages", "nut free", "dairy free", "ice-cream", "beans", "pankakes", "low fat mozarella"]


// MARK: Tag model
struct ThisTag: Identifiable {
    var id = UUID().uuidString
    var name: String
   
}
*/
