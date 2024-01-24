//
//  TagView.swift
//  Flavorly
//
//  Created by Timea Bartha on 18/1/24.
//

import SwiftUI

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

