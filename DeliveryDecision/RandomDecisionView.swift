//
//  RandomDecisionView.swift
//  DeliveryDecision
//
//  Created by 이석민 on 2022/09/05.
//

import SwiftUI

struct RandomDecisionView: View {
    @State var SelectedMenu: [String]
    @Environment(\.presentationMode) var presentationMode
    
    func getImage(named: String) -> Image {
       let uiImage =  (UIImage(named: named) ?? UIImage(named: "menu_null"))!
       return Image(uiImage: uiImage)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let random = SelectedMenu.randomElement() {
                Text("지금 먹을 음식은 \(random)입니다!")
                    .font(.title2.bold())
                    .padding()
                VStack(spacing: 0) {
                    getImage(named: random).padding()
                    Text("\(random)")
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    AngularGradient(gradient: Gradient(colors: [Color(hex: "4776E6"), Color(hex: "#8E54E9")]), center: .topLeading, angle: .degrees(180 + 45))
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 15, x: 10, y: 10)
                .shadow(color: .white, radius: 15, x: -10, y: -10)
                .padding()
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("다시하기").padding()
            })
            .background(Color(hex: "1D1B68"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
        }.navigationBarBackButtonHidden(true)
    }
}

struct RandomDecisionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RandomDecisionView(SelectedMenu: [""])
        }
    }
}


