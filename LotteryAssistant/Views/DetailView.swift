//
//  DetailView.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/5/10.
//

import SwiftUI


struct DetailView: View {
    
   
    
    let lottery:Lottery
   
    @State private var tag:String = "1_2"
   
    @StateObject private var dataStore:DataStore = DataStore()
    
    @State private var lotterys:[Lottery] = []
    
    var body: some View {
       
        content
            
            .task {
                dataStore.update(lottery: lottery)
                await updateLotterys()
            }
            .onChange(of: tag) { newValue in
                Task{ await updateLotterys()}
            }
            
    }
    
    
   
    
    
    private var content:some View{

            List{
                Section{
                    LotteryView(lottery: lottery, tag: .constant(""))
                }header: {
                    LotteryView.header(lottery: lottery)
                }
                
               
                Section {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .center, spacing: 1, pinnedViews: [.sectionHeaders]){
                            ForEach(lotterys){
                                LotteryView(lottery: $0, tag: $tag)
                                    .frame(width: nil, height: 44, alignment: .center)
                                if let index = lotterys.firstIndex(of: $0),index != lotterys.count - 1{
                                    Divider().frame(width: 250, alignment: .center)
                                }
                               
                            }
                            
                        }
                    }
                    
                } header: {
                    pickView()
                }

            }
            .navigationTitle("相似数据")
        
    }
  
    
    private func pickerItem(key:String) ->some View{
        if let lotterys = dataStore.value(forKey: "lotterys\(key)") as? [Lottery],!lotterys.isEmpty{
            return AnyView(Text(key).tag(key))
        }else{
            return AnyView(EmptyView())
        }
    }
   
    
    private func pickView() ->some View{
        GeometryReader { proxy in
            Picker("picker", selection: $tag) {
                pickerItem(key: "1_2")
                pickerItem(key: "1_3")
                pickerItem(key: "1_4")
                pickerItem(key: "1_5")
                pickerItem(key: "1_6")
               
                pickerItem(key: "2_3")
                pickerItem(key: "2_4")
                pickerItem(key: "2_5")
                pickerItem(key: "2_6")
                pickerItem(key: "2_7")
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .pickerStyle(.segmented)
        }
        .frame(height: 44, alignment: .center)
        
    }
    
    
    private func updateLotterys() async{
        if let lotterys = dataStore.value(forKey: "lotterys\(tag)") as? [Lottery]{
            self.lotterys = lotterys
        }
    }
    
   
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(lottery: .preview)
            .environmentObject(DataSource.shared)
            
    }
}




