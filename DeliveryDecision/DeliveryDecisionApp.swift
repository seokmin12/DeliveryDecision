//
//  DeliveryDecisionApp.swift
//  DeliveryDecision
//
//  Created by 이석민 on 2022/09/05.
//

import SwiftUI

@main
struct DeliveryDecisionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(SelectedMenuList: SelectedMenu())
        }
    }
}
