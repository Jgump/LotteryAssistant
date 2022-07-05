//
//  ContentView.swift
//  LotteryAssistant
//
//  Created by Jgump on 2022/3/20.
//

import SwiftUI


struct ContentView: View{
   
  
    @EnvironmentObject var dataSource:DataSource
    
    @State private var lotterys:[Lottery] = []
    
    @State private var isPersentAttributeListPage:Bool = false
    
    @State private var popNewLotteryView:Bool = false
    
    @State private var dataForYear:Int = 2023
    
    @State private var title:String = "2022"
    //MARK: - body
    var body: some View{
        navigationView
            .onAppear(perform: {
                update()
               
                   
                
            })
            .onChange(of: dataForYear) { newValue in
                update(year: newValue)
            }
    
    }
    
        
    
    //MARK: - Link Section
    private func section(lottery:Lottery) ->some View{
        Section {
            NavigationLink(destination: {
                DetailView(lottery: lottery)
                   
            }, label: {
                
                LotteryView(lottery: lottery,tag: .constant("")).id(lottery.issue)
                    
   
            })
        }header: {
            LotteryView.header(lottery: lottery)
        }
    }
    
  
    private var bottomView:some View{
        GeometryReader { proxy in
            ActivityIndicator.loading()
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .onAppear {
                   
                    dataForYear -= 1
                    
                }
                
               
        }
    }
    
    private func scrollToTopView(scrollViewProxy:ScrollViewProxy) ->some View{
        Circle().fill(.white).shadow(color: .gray, radius: 5, x: 0, y: 0)
            .frame(width: 40, height: 40, alignment: .center)
            .overlay(content: {
                Image(systemName:"chevron.up")
                    .foregroundColor(.black)
            })
        
        
        
            .alignmentGuide(HorizontalAlignment.trailing) { context in
                context.width + 20
                
            }
            .alignmentGuide(VerticalAlignment.bottom) { context in
                context.height + 20
            }
            .onTapGesture {
                withAnimation(.default) {
                    scrollViewProxy.scrollTo("top")
                }
            }
        
    }
    
    //MARK: - NavigationView
    private var navigationView:some View{
        ScrollViewReader { scrollViewProxy in
            NavigationView{
                List{
                    EmptyView().id("top")
                    
                    ForEach(lotterys) { lottery in
                        section(lottery: lottery)
                            .onAppear {
                                title = lottery.year.description
                            }
                           
                        
                    }
                    
                    bottomView
                    
                   
                }
                .navigationTitle(title)
                .fullScreenCover(isPresented: $isPersentAttributeListPage, content: { AttributeList(isPersented:$isPersentAttributeListPage)
                        .environmentObject(dataSource)
                })
                .popover(isPresented: $popNewLotteryView, content: {NewLotteryView(popNewLotteryView: $popNewLotteryView, displayData: $lotterys)})
                .toolbar {toolItems()}
                .overlay(alignment: .bottomTrailing) {
                    scrollToTopView(scrollViewProxy: scrollViewProxy)
                        .onAppear {
                           // dataForYear -= 1
                        }
                }
            }
            
        }
        
        
    }
           
    //MARK: - tools
    private func toolItems() ->some View{
        HStack(spacing:5) {
           
            //MARK: addNewLotteryButton
            Button {
                popNewLotteryView = !popNewLotteryView
            } label: {
                Image(systemName: "plus.circle")
            }

           

            //MARK: persent AttributeListPage
            Button {
                isPersentAttributeListPage = true
                
            } label: {
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                
                
            }

        }
    }
    
    
   
    
    
   
   
  
    
  
}
extension ContentView{
  
    
 
    func update(year:Int = 2022){
        Task{
       
            let result = await Task{dataSource.lotterys(year:year)}.value
            let sorted = result.sorted{$0.issue > $1.issue}
            
                
            
        DispatchQueue.main.async {
            if lotterys.isEmpty{
                withAnimation {
                    self.lotterys = sorted
                }
                
            }else{
                withAnimation {
                    
                    self.lotterys.append(contentsOf: sorted)
                }
               
            }
            
        }
        }
    }
}

    
 //MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(DataSource.shared)
            
        
    }
    
}




