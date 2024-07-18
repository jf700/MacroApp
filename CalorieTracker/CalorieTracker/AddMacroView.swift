//
//  AddMacroView.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 7/6/24.
//

import SwiftUI

struct AddMacroView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var food = ""
    @State private var date = Date()
    @State private var showAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack (spacing: 20){
                Text("Add Macro")
                    .font(.largeTitle)
                
                TextField("What did you eat?", text: $food)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                    )
                DatePicker("Date", selection: $date)
                
                Button{
                    if food.count > 2{
                        sendItemToGPT()
                    }
                } label: {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(uiColor: .label))
                            )
                }
            }
            .padding(.horizontal)
            .alert("Error", isPresented: $showAlert){
                Text("Ok")
            } message: {
                Text("We were unable to make your request. Please make sure you enter a valid food item and try again")
            }
        }
    }
    
    private func sendItemToGPT(){
        Task{
            do{
                let result = try await OpenAiService.shared.sendPromptToChatGPT(message: food)
                saveMacro(result)
                dismiss()
            } catch{
                if let openAIError = error as? OpenAiError{
                    switch openAIError {
                    case .noFunctionCall:
                        showAlert = true
                    case.unableToConverStringIntoData:
                        print(error.localizedDescription)
                    }
                    
                }else{
                    print(error.localizedDescription)
                }
            }
        }
    }
    private func saveMacro(_ result: MacroResult){
        let macro = Macro(food: result.food, createdAt: .now, date: date, carbs: result.carbs, fats: result.fats, protein: result.protein)
        modelContext.insert(macro)
    }
}

#Preview {
    AddMacroView()
}
