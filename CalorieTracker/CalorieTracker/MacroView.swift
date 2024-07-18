//
//  MacroView.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 6/4/24.
//

import SwiftUI
import SwiftData


struct MacroView: View {
    @State var carbs = 0
    @State var fats = 0
    @State var proteins = 0
    
    @Query var macros: [Macro]
    @State var dailyMacros = [DailyMacro]()
    @State var showTextField = false
    @State var food = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical){
                VStack(){
                    Text("Today's Macros")
                        .font(.largeTitle)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider().background(.black)
                        .padding(.horizontal)
                    MacroHeaderView(carbs: carbs, fats: fats, proteins: proteins)
                        .padding()
                    
                    VStack(alignment: .leading){
                        Text("Previous")
                            .font(.title)
                        Divider().background(.black)
                            .padding(.horizontal)
                        ForEach(dailyMacros){ macro in
                            MacroDayView(macro:macro)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .scrollIndicators(.hidden)
            .toolbar{
                ToolbarItem{
                    Button{
                        showTextField = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(isPresented: $showTextField) {
                AddMacroView()
            }
            .onAppear {
                fetchDailtyMacros()
                fetchTodaysMacros()
            }
            .onChange(of: macros){ _, _ in
                fetchDailtyMacros()
                fetchTodaysMacros()
            }
        }
    }
    private func fetchDailtyMacros(){
        let dates: Set<Date> = Set(macros.map({ Calendar.current.startOfDay(for: $0.date) }))
        
        var dailyMacros = [DailyMacro]()
        for date in dates{
            let filterMacros = macros.filter({ Calendar.current.startOfDay(for: $0.date) == date })
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            let protein: Int = filterMacros.reduce(0, { $0 + $1.protein })
            
            let macro = DailyMacro(date: date, carbs: carbs, fats: fats, protein: protein)
            dailyMacros.append(macro)
        }
        self.dailyMacros = dailyMacros.sorted(by: { $0.date > $1.date })
    }
    private func fetchTodaysMacros(){
        if let firstDateMacro = dailyMacros.first, Calendar.current.startOfDay(for: firstDateMacro.date) == Calendar.current.startOfDay(for: .now){
            carbs = firstDateMacro.carbs
            fats = firstDateMacro.fats
            proteins = firstDateMacro.protein

        }
    }
}

#Preview {
    NavigationStack{
        MacroView()
    }
}
