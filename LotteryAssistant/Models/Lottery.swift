//
//  _Lottery.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/5/21.
//

import Foundation
import SwiftUI

class Lottery:NSObject,Identifiable{
    let index:Int
    @objc let issue:String
    
    @objc let num1:Int
    @objc let num2:Int
    @objc let num3:Int
    @objc let num4:Int
    @objc let num5:Int
    @objc let num6:Int
    @objc let num7:Int
    
    @objc let date:String
    @objc var year:Int{
        guard let yearString = date.split(separator: "-").map({$0.description}).first,
        let year = Int(yearString)
        else {return 0}
        return year
    }
    
    
    var redNums:[Int]{[num1,num2,num3,num4,num5,num6]}
    var dir:Dictionary<String,Any>{
        ["issue":issue,"date":date,"numbers":"\(num1),\(num2),\(num3),\(num4),\(num5),\(num6),\(num7)"]
    }
    
    @objc var sumValue:Int{
        redNums.reduce(0) { $0 + $1 }
    }
    
    

    override var description: String{
        "[issue:\(issue),date:\(date),num1:\(num1),num2:\(num2),num3:\(num3),num4:\(num4),num5:\(num5),num6:\(num6),num7:\(num7)]"
    }
    
  
     //MARK: - base init
    init(index:Int,_ issue:String,_ date:String,_ num1:Int,_ num2:Int,_ num3:Int,_ num4:Int,_ num5:Int,_ num6:Int,_ num7:Int){
        self.index = index
        self.issue = issue
        self.date = date
        self.num1 = num1
        self.num2 = num2
        self.num3 = num3
        self.num4 = num4
        self.num5 = num5
        self.num6 = num6
        self.num7 = num7
        super.init()
    }
    
    //MARK: - init from dir
    init?(dir:Dictionary<String,Any>){
        guard let index = dir["index"] as? Int,
            let issueRawValue = dir["issue"] as? String,
              let dateRawValue = dir["date"] as? String,
              let numsStringValue = dir["nums"] as? String
              
        else {return nil}
        let numValues = numsStringValue.split(separator: ",").compactMap{Int($0)}
        guard numValues.count >= 7 else {return nil}
        self.index = index
        self.issue = issueRawValue
        self.date = dateRawValue
        self.num1 = numValues[0]
        self.num2 = numValues[1]
        self.num3 = numValues[2]
        self.num4 = numValues[3]
        self.num5 = numValues[4]
        self.num6 = numValues[5]
        self.num7 = numValues[6]
        super.init()
        
      
        
    }
    
    //MARK: - init for strings
    init?(issue:String,date:String,separator:Character,numsString:String){
        let nums = numsString.split(separator: separator).compactMap{Int($0)}
        guard nums.count == 7 else {return nil}
        self.index = 1000
        self.issue = issue
        self.date = date
        self.num1 = nums[0]
        self.num2 = nums[1]
        self.num3 = nums[2]
        self.num4 = nums[3]
        self.num5 = nums[4]
        self.num6 = nums[5]
        self.num7 = nums[6]
    }
    
    static let preview:Lottery = Lottery(index:100,"max","2022-5-17",28, 29, 30,31, 32,33, 16)
    static let preview_min:Lottery = Lottery(index:0,"Min", "2022-5-8", 1, 2, 3, 4, 5, 6, 7)
    
}

// MARK: - ACValue
extension Lottery{

    var acValue:Int{
        var values:Set<Int> = []
        values.update(with: num6 - num1)
        values.update(with: num6 - num2)
        values.update(with: num6 - num3)
        values.update(with: num6 - num4)
        values.update(with: num6 - num5)
        
        values.update(with: num5 - num1)
        values.update(with: num5 - num2)
        values.update(with: num5 - num3)
        values.update(with: num5 - num4)
        
        values.update(with: num4 - num1)
        values.update(with: num4 - num2)
        values.update(with: num4 - num3)
        
        values.update(with: num3 - num1)
        values.update(with: num3 - num2)
        
        values.update(with: num2 - num1)
       
        return values.count - (6 - 1)
        
        
    }
    
    var acValue1_3:Int{
        var values:Set<Int> = []
        values.update(with: num3 - num1)
        values.update(with: num3 - num2)
        
        values.update(with: num2 - num1)
        return values.count - (3 - 1)
    }
    
}
// MARK: - next and last
extension Lottery:Sequence,IteratorProtocol{
    
    
    
    var last:Lottery?{
        let result = DataSource.shared.lotterys(year: self.year)
        if let next = result.filter({$0.index == self.index - 1}).first{
            return next
        }else{
            return nil
        }
    }
    typealias Element = Lottery
    func next() -> Lottery? {
        let result = DataSource.shared.lotterys(year: self.year)
        if let next = result.filter({$0.index == self.index + 1}).first{
            return next
        }else{
            return nil
        }
    }

}


//MARK: - BL

extension Lottery{
    
    private func values(keysRange:ClosedRange<Int>) ->[Int]{keysRange.compactMap{"num\($0)"}.compactMap{self.value(forKey:$0) as? Int}}
    
    func sumValue(keysRange:ClosedRange<Int>) ->Int{ values(keysRange: keysRange).reduce(0){$0 + $1}}
    
    func oddAndEven_BL(keysRange:ClosedRange<Int>) ->(Int,Int){
       
        var oddCount:Int = 0
        var evenCount:Int = 0
        values(keysRange: keysRange).forEach { value in
            guard value.isMultiple(of: 2) else {oddCount += 1;return}
            evenCount += 1
        }
        return (oddCount,evenCount)
    }
    
    func region_BL(keysRange:ClosedRange<Int>) ->(Int,Int,Int){
        var r1:Int = 0
        var r2:Int = 0
        var r3:Int = 0
        values(keysRange: keysRange).forEach { value in
            if (1...11).contains(value){
                r1 += 1
            }else if (12...22).contains(value){
                r2 += 1
            }else{
                r3 += 1
            }
        }
        
        return (r1,r2,r3)
    }
    
    func remainder_BL(keysRange:ClosedRange<Int>) ->(Int,Int,Int){
        var v0 = 0
        var v1 = 0
        var v2 = 0
        values(keysRange:keysRange).forEach { value in
            switch value % 3{
                case 0:v0 += 1;break
                case 1:v1 += 1;break
                case 2:v2 += 1;break
                default:break
            }
        }
        return (v0,v1,v2)
    }
    
    
    
}

//MARK: - odd and evens
extension Lottery{
    
   
    var oddAndEvens:[String]{
      values(keysRange: 1...6).map{$0.isMultiple(of: 2) ? "偶" : "奇"}
        
    }
    
    var oddAndEvensDescription:String{
        oddAndEvens.reduce("") { $0 + $1 }
    }
    
    var regions:[Int]{
        values(keysRange: 1...6).compactMap { num ->Int? in
            switch num{
                case 1...11:return 1
                case 12...22:return 2
                case 23...33:return 3
                default:return nil
            }
        }
    }
    
    var regionsDescription:String{
        regions.reduce("") { $0.description + $1.description}
           
    }
    
    var remainders:[Int]{
        values(keysRange: 1...6).map{$0 % 3}
    }
    
    var remaindersDescription:String{
        remainders.reduce("") { $0.description + $1.description}
        
    }
}

