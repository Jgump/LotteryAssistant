//
//  DataSource.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/6/25.
//

import Foundation
import Metal

class DataSource:ObservableObject{
    
    
    private static var cache:[String:[Lottery]] = [:]
    
    enum State:String{
        case Bundle,File,Cache
    }
    
    
    @Published var dataFrom:State = .Bundle
    
    
    
    private init(){}
    static let shared = DataSource()
    
    
    
    
    
    
    func lotterys(year:Int) ->[Lottery]{
        guard let url = Bundle.main.url(forResource:year.description, withExtension: "plist") else {fatalError()}
        guard let data = try? Data(contentsOf:url) else {fatalError()}
        guard let dirs = try? PropertyListSerialization.propertyList(from: data, format: .none) as? [Dictionary<String,Any>] else {fatalError()}
        return dirs.compactMap{Lottery(dir: $0)}
    }
    
    func fullData() ->[Lottery]{
        var result:[Lottery] = []
        for year in (2003...2022){
            
            result.append(contentsOf: lotterys(year: year))
            
        }
        
        return result
        
    }
   

    
    
}

