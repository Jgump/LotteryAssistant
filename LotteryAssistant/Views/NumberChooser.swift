//
//  LotteryBuilder.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/7/2.
//

import SwiftUI

struct NumberChooser: View {
    @Binding var redNums:[Int]
    @Binding var blueNums:[Int]
    
    var body: some View {
        content
            .animation(.default, value: redNums)
            .animation(.default, value: blueNums)
    }
    
    
    private func circleItem(value:Int,fill color:Color) ->some View{
        ZStack {
            Circle().fill(color)
            Text(value < 10 ? "0\(value)" : value.description)
                .font(.subheadline.bold().monospaced())
                .foregroundColor(.white)
        }
    }
    
    
    private func item(range:ClosedRange<Int>,fill color:Color,nums:Binding<[Int]>,value: @escaping(Int) ->Void) ->some View{
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 5) {
                ForEach(range,id:\.self){ num in
                   
                    circleItem(value: num, fill: nums.wrappedValue.contains(num) ? .gray : color)
                    .frame(width: 25, height: 25, alignment: .center)
                    .onTapGesture {
                        value(num)
                       
                    }
                    

                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }
    
    
    
    private func redPlace(handler:@escaping (Int) ->Void) ->some View{
        GeometryReader { proxy in
            
            VStack {
                item(range: 1...11,fill: .pink, nums: $redNums,value: handler)
                item(range: 12...22,fill: .pink, nums: $redNums,value: handler)
                item(range: 23...33,fill: .pink, nums: $redNums,value: handler)
            }
            .background(Color(uiColor: .systemGray5))
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            
        }
        .frame(width:UIScreen.main.bounds.width * 0.97,height:100, alignment: .center)
        .cornerRadius(5)
        
    }
    
    private func bluePlace(handler:@escaping (Int) ->Void) ->some View{
        GeometryReader { proxy in
            
            VStack(alignment: .leading, spacing: 5) {
                item(range: 1...11,fill: .blue, nums: $blueNums,value: handler)
                item(range: 12...16,fill: .blue, nums: $blueNums,value: handler)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .background(Color(uiColor: .systemGray5))
        .frame(width:UIScreen.main.bounds.width * 0.97,height: 60, alignment: .center)
        .cornerRadius(5)
    }
    
    private var resultView:some View{
        GeometryReader { proxy in
            HStack {
               
                    ForEach(redNums,id:\.self){num in
                        circleItem(value: num, fill: .pink)
                    }

                    ForEach(blueNums,id:\.self){
                        circleItem(value: $0, fill: .blue)
                    }
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
           
            
        }
        .background(Color(uiColor: .systemGray5))
        .frame(width:UIScreen.main.bounds.width * 0.9,height: 25, alignment: .center)
        
        .cornerRadius(20)
        .padding(5)
        .overlay(alignment: .leading) {
            Text(redNums.count.description)
                .font(.caption2.bold().monospaced())
                .foregroundColor(.red)
                .alignmentGuide(HorizontalAlignment.leading) { context in
                    context.width / 2 + 5
                }
        }
        .overlay(alignment: .trailing) {
            Text(blueNums.count.description)
                .font(.caption2.bold().monospaced())
                .foregroundColor(.blue)
                .alignmentGuide(HorizontalAlignment.trailing) { context in
                    context.width / 2 - 5
                }
        }
    }
    
 
    
    var content:some View{
        
        VStack(spacing:20){
           
            resultView
            redPlace {removeOrAdd(num: $0, nums: $redNums)}
            bluePlace{removeOrAdd(num: $0, nums: $blueNums)}
        }
        
        
    }
    
    func removeOrAdd(num:Int,nums:Binding<[Int]>){
        guard nums.wrappedValue.contains(num),
              let index = nums.wrappedValue.firstIndex(of: num) else {nums.wrappedValue.append(num);return}
        nums.wrappedValue.remove(at: index)
    }
}


struct LotteryPreview:View{
    @State private var redNums:[Int] = []
    @State private var blueNums:[Int] = []
    var body: some View{
        NumberChooser(redNums: $redNums, blueNums: $blueNums)
    }
}

struct LotteryBuilder_Previews: PreviewProvider {
    static var previews: some View {
        LotteryPreview()
    }
}
