//
//  TodolistTestApp.swift
//  TodolistTest
//
//  Created by Clarissa Alverina on 17/06/24.
//

import SwiftUI

@main
struct TodolistTestApp: App {
    var body: some Scene {
        WindowGroup {
//            SheetView()
            SheetViewCustom().preferredColorScheme(.light).accentColor(Color(hex: 0x4CB4A7))
        }.modelContainer(for: Task.self)
    }
}
