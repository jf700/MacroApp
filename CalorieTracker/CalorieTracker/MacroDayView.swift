//
//  MacroDayView.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 7/7/24.
//

import SwiftUI



struct MacroDayView: View {
    @State var macro: DailyMacro
    

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(macro.date.monthAndDay)
                    .font(.title2)
                Text(macro.date.year)
            }
            .frame(width: 80, alignment: .leading)
           
            
            HStack{
                VStack{
                    Text("Carbs")
                    Text("\(macro.carbs) g")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.1))
                )
                 
                
                VStack{
                    Text("Fats")
                    Text("\(macro.fats) g")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.1))
                )
                
                VStack{
                    Text("Protein")
                    Text("\(macro.protein) g")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.1))
                )
            }
        }
    }
}

#Preview {
    MacroDayView(macro: DailyMacro(date: .now, carbs: 123, fats: 51, protein: 152))
}
