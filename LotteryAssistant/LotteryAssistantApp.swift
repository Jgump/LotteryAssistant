//
//  LotteryAssistantApp.swift
//  LotteryAssistant
//
//  Created by Jgump on 2021/12/8.
//

import SwiftUI




@main
struct LotteryAssistantApp: App {
    @StateObject private var dataSource:DataSource = .shared
    var body: some Scene {
    WindowGroup {
          ContentView()
                .environmentObject(dataSource)
                
        }
        
    }
    
}




    
    


