//
//  NewLotteryView.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/6/17.
//

import SwiftUI


struct NewLotteryView: View {
    
    @Binding var popNewLotteryView:Bool
    @Binding var displayData:[Lottery]
    
    @State private var issue:String = "22077"
    @State private var date:String = "2022-6-19"
    @State private var nums:String = "20,25,29,31,32,33,16"
    
    @State private var lotterys:[Lottery] = []
   
    
    
    
    var body: some View {
        NavigationView{
            List{
                if !lotterys.isEmpty{
                    Section{
                        ForEach(lotterys) { lottery in
                            LotteryView(lottery: lottery, tag: .constant(""))
                                .swipeActions {
                                    Button {
                                        if let index = lotterys.firstIndex(of: lottery){
                                            Task{
                                                withAnimation {
                                                    lotterys.remove(at: index)
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.bin.circle.fill")
                                    }
                                    .tint(.pink)

                                }
                        }
                    }
                }
                Section("issue") {
                    TextField("issue", text: $issue)
                }
                Section("date"){
                    TextField("date",text: $date)
                }
                
                Section("nums") {
                    TextField("nums", text: $nums)
                }
                
               
                    Section{
                       candidateButton
                        saveButton
                    }
                    .frame(alignment: .center)
                    .font(.caption2)
                
                
                
            }
            .toolbar(content: {
                Button {
                    popNewLotteryView = false
                } label: {
                    Image(systemName: "xmark.circle")
                }

            })
            .navigationTitle("New Lottery")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
 .animation(.default, value: nums)
        
        
    }
    
    var candidateButton:some View{
        GeometryReader{ proxy in
        Button("添加到待选区") {
            if let lottery = Lottery(issue: issue, date: date, separator: ",", numsString: nums){
                withAnimation {
                    lotterys.append(lottery)
                }
            }
            
            issue = ""
            date = ""
            nums = ""
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }
    
    
    var saveButton:some View{
        GeometryReader{ proxy in
            Button("保存数据"){
                popNewLotteryView = false
                Task{
                    let dir = ["issue":issue,"date":date,"numbers":nums]
                    if let newLottery = Lottery(dir: dir){
                        withAnimation(.default) {
                            displayData.insert(newLottery, at: 0)
                            
                        }
                       
                    }
                }
                
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }

    }
    
   
    
    
}



struct NewLotteryView_Previews: PreviewProvider {
   
    static var previews: some View {
        NewLotteryView(popNewLotteryView: .constant(false), displayData: .constant([]))
            
        
    }
}

