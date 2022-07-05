//
//  ActivityIndicator.swift
//  LotteryAssistant
//
//  Created by Jgump on 2021/12/30.
//

import Foundation
import SwiftUI
import UIKit

struct ActivityIndicator:UIViewRepresentable{
    
    
    typealias UIViewType = UIActivityIndicatorView
    
    
    
    let isAnimating:Bool
    
    let style:UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
    
    static func loading(isAnimation:Bool = true) ->ActivityIndicator{
        
         ActivityIndicator(isAnimating: isAnimation, style: .medium)
    }
    
    
}




