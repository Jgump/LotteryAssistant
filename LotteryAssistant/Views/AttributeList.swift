//
//  AttributeList.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/6/13.
//

import SwiftUI

struct AttributeList: View {
    
    @EnvironmentObject var dataSource:DataSource
    
    @Binding var isPersented:Bool
    
 
    @State private var lotterys:[Lottery] = []
    
    @State private var currentTag:String = ""
    
    
    
    
    var body: some View {
        content
            
            .task {
                let result = dataSource.lotterys(year: 2022)
                self.lotterys = result
            }
           
           
          
          
    }
    
    private func text(_ str:String,_ proxy:GeometryProxy,tag:String,_ isTap:Bool = false)->some View{
        Group {
            GeometryReader { proxy in
                Text(str)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .foregroundColor(str == "3:3" ? .blue : str == "2:2:2" ? .pink : nil)
                   
            }
            .frame(width: proxy.size.width / 6,height: proxy.size.height, alignment: .center)
            .onTapGesture {
                if isTap{
                    if currentTag == tag{
                        currentTag = ""
                    }else{
                        currentTag = tag
                    }
                }
            }
            .opacity(currentTag == "" ? 1 : currentTag == tag ? 1 : 0.2)
            Divider()
                .frame( height: proxy.size.height + 1, alignment: .center)
                //.background(.primary)
            
        }
       
    }
    
    private func row(lottery:Lottery) ->some View{
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0) {
                text(lottery.issue,proxy, tag: "issue")
                    .foregroundColor(.gray)
                    .font(.system(size: 9).monospaced())
               
                
                text(lottery.sumValue(keysRange: 1...6).description,proxy, tag: "sum")
                   
                text("\(lottery.oddAndEven_BL(keysRange: 1...6).0):\(lottery.oddAndEven_BL(keysRange: 1...6).1)",proxy, tag: "odd")
                    
                text("\(lottery.region_BL(keysRange: 1...6).0):\(lottery.region_BL(keysRange: 1...6).1):\(lottery.region_BL(keysRange: 1...6).2)",proxy,tag: "reg")
                    
                text("\(lottery.remainder_BL(keysRange: 1...6).0):\(lottery.remainder_BL(keysRange: 1...6).1):\(lottery.remainder_BL(keysRange:1...6).2)",proxy,tag: "rem")
                    
                text(lottery.acValue.description,proxy,tag: "ac")
                   
                    
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .font(.caption2.smallCaps().monospaced())
        }
    }

    
    
    private var content:some View{
        ScrollViewReader { scrollViewProxy in
            
            NavigationView{
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVStack(alignment: .center, spacing: 1, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(lotterys) { lottery in
                                row(lottery: lottery)
                                    .frame( height: 40, alignment: .center)
                                    .font(.caption.monospaced())
                                Divider()
                                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                                
                            }
                        } header: {
                            header
                        }
                        
                        
                    }
                    .toolbar {
                        Button {
                            isPersented = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .tint(.gray)
                        }
                        
                    }
                })
                .padding()
                .navigationTitle("Attribute List")
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
    }
    
    private var header:some View{
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0) {
                text("期数",proxy, tag: "issue",true)
                    
                   
                text("和值",proxy,tag: "sum",true)
                    
                  
                text("奇偶",proxy,tag: "odd",true)
                    
                   
                text("区位",proxy,tag:"reg",true)
                    
                    
                text("%3",proxy,tag: "rem",true)
                   
                   
                text("AC",proxy,tag: "ac",true)
                   
                   
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .font(.caption2.bold())
            
        }
        .padding([.top,.bottom])
        .background(Color(UIColor.systemGray5))
        .cornerRadius(5)
       
    }
    
//    private func update() async{
//        let result = await Task{dataSource.loadData(from: nil, year: 0)}.value
//        
//        DispatchQueue.main.async {
//            self.lotterys = result
//        }
//        
//    }
    
    
}
extension AttributeList{
   
}

struct AttributeList_Previews: PreviewProvider {
    static var previews: some View {
        AttributeList(isPersented: .constant(false))
            .environmentObject(DataSource.shared)
    }
}

