//
//  NewLotteryView.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/6/23.
//

import SwiftUI

struct LotteryView: View {
    
    let lottery:Lottery
    @Binding var tag:String
    
    @StateObject private var dataStore:DataStore = DataStore()
    
    
    var body: some View {
        content
            .task {
                if tag.isEmpty{
                    dataStore.update(lottery: lottery)
                }
               
            }
    
        
    }
    
}

extension LotteryView{
    
    //MARK: - badgeView
    private func badgeView(count:Int) ->some View{
        guard count != 0 else {return AnyView(EmptyView())}
        
        return AnyView( Text(count.description)
            .font(.system(size: 9))
            .foregroundColor(.purple)
        )
    }
    
    //MARK: - is fill
    private func isFill(num:Int) ->Bool{
        if !tag.isEmpty{
            let keysIntValues = tag.split(separator:"_").compactMap{Int($0.description)}
            let range:ClosedRange<Int> = keysIntValues.first!...keysIntValues.last!
            let values = range.compactMap{lottery.value(forKey:"num\($0)") as? Int}
            
            return values.contains(num)
        }else{
            guard let nextLottery = lottery.last else {return false}
            return nextLottery.redNums.contains(num)
        }
    }
    
    
    //MARK: - circle
    private func circle(top:Int,bottom:Int,fill:Color,div:Bool = true) ->some View{
        Circle()
            .fill(fill.opacity(0.3))
            .frame(width: 22, height: 22, alignment: .center)
            .padding(tag.isEmpty ? 8 : 0)
            .overlay(alignment: .topTrailing) { if tag.isEmpty {badgeView(count: top)}}
            .overlay(alignment: .bottomTrailing) {if tag.isEmpty {badgeView(count: bottom)}}
            .overlay(alignment: .trailing) { if div{Divider().frame(height: 5, alignment: .center)}}
               
            
    }
    
    //MARK: - numItem
    private func numItem(num:Int,top:Int,bottom:Int) ->some View{
        let fill:Color = isFill(num: num) ? .orange : .init(uiColor: .systemBackground)
        let div = num != lottery.num7
        return circle(top: top, bottom: bottom,fill:fill,div: div)
            .overlay {
                Text(num < 10 ? "0\(num)" : num.description)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(num == lottery.num7 ? .blue : nil)
            }
    }
    
    //MARK: - content
    private var content:some View{
        GeometryReader { proxy in
            
            HStack {
                if !tag.isEmpty{
                    Text(lottery.issue).font(.caption2.smallCaps().bold()).foregroundColor(.gray)
                }
                HStack(alignment: .center, spacing: tag.isEmpty ? 2 : 5) {
                    numItem(num: lottery.num1, top: dataStore.lotterys1.count, bottom: 0)
                    numItem(num: lottery.num2, top: dataStore.lotterys1_2.count, bottom: dataStore.lotterys2.count)
                    numItem(num: lottery.num3, top: dataStore.lotterys1_3.count, bottom: dataStore.lotterys2_3.count)
                    numItem(num: lottery.num4, top: dataStore.lotterys1_4.count, bottom: dataStore.lotterys2_4.count)
                    numItem(num: lottery.num5, top: dataStore.lotterys1_5.count, bottom: dataStore.lotterys2_5.count)
                    numItem(num: lottery.num6, top: dataStore.lotterys1_6.count, bottom:dataStore.lotterys2_6.count)
                    numItem(num: lottery.num7, top: dataStore.lotterys1_7.count, bottom: dataStore.lotterys2_7.count)
                }
            }
            .frame(width:proxy.size.width, height: proxy.size.height, alignment: .center)
        }
       
    }
    
    
    //MARK: - header
    static func header(lottery:Lottery) ->some View{
        GeometryReader { proxy in
            HStack{
                Text(lottery.issue).frame(width: proxy.size.width / 2, alignment: .leading)
                Text(lottery.date).frame(width: proxy.size.width / 2, alignment: .trailing)
            }
            
            .font(.caption)
        }
        .padding([.top,.bottom],5)
        
        
    }
    
}

//MARK: - Preview
struct LotteryView_Previews: PreviewProvider {
    
    private static func lottery() ->Lottery{
        DataSource.shared.lotterys(year: 2022).randomElement() ?? .preview
    }
    
    static var previews: some View {
        NavigationView{
        List{
            Section{
              
            LotteryView(lottery:lottery(),tag: .constant(""))
                   

            }header: {
                LotteryView.header(lottery: lottery())
            }
            
          
            LotteryView(lottery: lottery(), tag: .constant("1_2"))
                
        }
        
    }
    }
}
