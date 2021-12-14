//
//  CustonAlert.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 22.11.21.
//

import SwiftUI

struct CustomAlertView<Content:View>: View {
    @EnvironmentObject var data : Data
    @State private var alertText = ""
    @Binding var categoryType: Bool
    @Binding var addCategoryAlert : Bool
    
    @ViewBuilder var content : () -> Content
    
    var body: some View {
        ZStack {
            content()
            if addCategoryAlert {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.black)
                        .opacity(0.90)
                    VStack {
                        Text("Enter Category Name")
                        TextField("", text: $alertText)
                            .background(Color(.systemGray5).cornerRadius(5))

                        Spacer()
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                addCategoryAlert.toggle()
                                alertText = ""
                            }
                            .frame(width: 60)
                            
                            Spacer()
                            
                            Divider()
                            
                            Spacer()
                            Button("Add"){
                                addCategoryAlert.toggle()
                                onAdd()
                                alertText = ""
                            }
                            .frame(width: 61)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                }
                .padding(25)
                .frame(height: 150)
                .offset(y: -30)
            }
        }
    }
    
    private func onAdd() {
        categoryType ? data.database.insertIncomeCategory(newCategory: alertText) : data.database.insertExpenseCategory(newCategory: alertText)
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(categoryType: .constant(false), addCategoryAlert: .constant(true), content: {})
            .preferredColorScheme(.dark)
        
    }
}
