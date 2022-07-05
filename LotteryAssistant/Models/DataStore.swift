//
//  DataStore.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/5/13.
//

import Foundation
import SwiftUI
import Combine

class DataStore:NSObject,ObservableObject{

    static let dataStoreCache = NSCache<NSString,DataStore>()
    static var lotterysCache:[Lottery] = []
  
  
    
  
    
    //MARK: - published Attributes
    @objc @Published var lotterys1:[Lottery] = []
    @objc @Published var lotterys1_2:[Lottery] = []
    @objc @Published var lotterys1_3:[Lottery] = []
    @objc @Published var lotterys1_4:[Lottery] = []
    @objc @Published var lotterys1_5:[Lottery] = []
    @objc @Published var lotterys1_6:[Lottery] = []
    @objc @Published var lotterys1_7:[Lottery] = []
   
    
    @objc @Published var lotterys2:[Lottery] = []
    @objc @Published var lotterys2_3:[Lottery] = []
    @objc @Published var lotterys2_4:[Lottery] = []
    @objc @Published var lotterys2_5:[Lottery] = []
    @objc @Published var lotterys2_6:[Lottery] = []
    @objc @Published var lotterys2_7:[Lottery] = []
  
   
    
    //MARK: - init
    override init(){super.init()}
    
  
    
    
    
    //MARK: - Update1_7
    private func update1_7(lottery:Lottery,lotterys:[Lottery]) {
        
        var res:[Lottery] = []
        var res1_2:[Lottery] = []
        var res1_3:[Lottery] = []
        var res1_4:[Lottery] = []
        var res1_5:[Lottery] = []
        var res1_6:[Lottery] = []
        var res1_7:[Lottery] = []
        
        
        lotterys.filter{$0.num1 == lottery.num1}.forEach { clottery in
            res.append(clottery)
            guard clottery.num2 == lottery.num2 ,clottery.issue != lottery.issue else {return}
            res1_2.append(clottery)
            guard clottery.num3 == lottery.num3  else {return}
            res1_3.append(clottery)
            guard clottery.num4 == lottery.num4 else {return}
            res1_4.append(clottery)
            guard clottery.num5 == lottery.num5 else {return}
            res1_5.append(clottery)
            guard clottery.num6 == lottery.num6 else {return}
            res1_6.append(clottery)
            guard clottery.num7 == lottery.num7 else {return}
            res1_7.append(clottery)
        
        }
        
        DispatchQueue.main.async {
            self.lotterys1 = res
            self.lotterys1_2 = res1_2
            self.lotterys1_3 = res1_3
            self.lotterys1_4 = res1_4
            self.lotterys1_5 = res1_5
            self.lotterys1_6 = res1_6
            self.lotterys1_7 = res1_7
        }

        
    }
       
  
       
       
    
    
    //MARK: - Update2_7
    private func update2_7(lottery:Lottery,lotterys:[Lottery]){
        
        var res:[Lottery] = []
        var res2_3:[Lottery] = []
        var res2_4:[Lottery] = []
        var res2_5:[Lottery] = []
        var res2_6:[Lottery] = []
        var res2_7:[Lottery] = []
        
        lotterys.forEach{ cLottery in
            
            guard cLottery.num2 == lottery.num2,cLottery.issue != lottery.issue else {return}
            res.append(cLottery)
            
            guard cLottery.num3 == lottery.num3 else {return}
            res2_3.append(cLottery)
            guard cLottery.num4 == lottery.num4 else {return}
            res2_4.append(cLottery)
            guard cLottery.num5 == lottery.num5 else {return}
            res2_5.append(cLottery)
            guard cLottery.num6 == lottery.num6 else {return}
            res2_6.append(cLottery)
            guard cLottery.num7 == lottery.num7 else {return}
            res2_7.append(cLottery)
            
        }

        DispatchQueue.main.async {
            self.lotterys2 = res
            self.lotterys2_3 = res2_3
            self.lotterys2_4 = res2_4
            self.lotterys2_5 = res2_5
            self.lotterys2_6 = res2_6
            self.lotterys2_7 = res2_7
        }
        
        
        
    }
    
    //MARK: - Update
    func update(lottery:Lottery){
       
        if let cacheDataStore = Self.dataStoreCache.object(forKey: NSString(string: lottery.issue)){
            
            self.lotterys1 = cacheDataStore.lotterys1
            self.lotterys2 = cacheDataStore.lotterys2
            self.lotterys1_2 = cacheDataStore.lotterys1_2
            self.lotterys1_3 = cacheDataStore.lotterys1_3
            self.lotterys1_4 = cacheDataStore.lotterys1_4
            self.lotterys1_5 = cacheDataStore.lotterys1_5
            self.lotterys1_6 = cacheDataStore.lotterys1_6
            self.lotterys1_7 = cacheDataStore.lotterys1_7
            self.lotterys2_3 = cacheDataStore.lotterys2_3
            self.lotterys2_4 = cacheDataStore.lotterys2_4
            self.lotterys2_5 = cacheDataStore.lotterys2_5
            self.lotterys2_6 = cacheDataStore.lotterys2_6
            self.lotterys2_7 = cacheDataStore.lotterys2_7
            
            print("\(type(of: self)) \(lottery.issue) from Cache. \(Date.now)")
        }else{
            Task{
                
                let lotterys:[Lottery] = {
                    guard Self.lotterysCache.isEmpty else {print("dataStore\(lottery.issue) fullData from Cahce." );return Self.lotterysCache}
                    let fullData = DataSource.shared.fullData()
                    Self.lotterysCache = fullData
                    print("dataStore\(lottery.issue) full data from dataStore.")
                    return fullData
                }()
                
               
                    self.update1_7(lottery: lottery,lotterys:lotterys)
                    self.update2_7(lottery: lottery,lotterys:lotterys)
                    Self.dataStoreCache.setObject(self, forKey: NSString(string: lottery.issue))
              
                
              
                
               

            }
        }
        
        
        
    }

   
    
}

    



