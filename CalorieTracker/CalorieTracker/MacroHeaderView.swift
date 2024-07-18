//
//  MacroItemView.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 6/6/24.
//

import SwiftUI

struct MacroHeaderView: View {
    var carbs: Int
    var fats: Int
    var proteins: Int
    
    var body: some View {
        HStack{
            Spacer()
            
            VStack{
                Text("Carbs")
                Text("\(carbs) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.1))
            )
             
            
            Spacer()
            
            VStack{
                Text("Fats")
                Text("\(fats) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.1))
            )
            Spacer()
            
            VStack{
                Text("Protein")
                Text("\(proteins) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.1))
            )
            Spacer()
        }
    }
}

//#Preview {
//    MacroHeaderView(carbs: .constant(18), fats: .constant(200), proteins: .constant(50))
//}
