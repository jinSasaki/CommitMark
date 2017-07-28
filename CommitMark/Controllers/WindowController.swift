//
//  WindowController.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

final class WindowController {
    static let shared = WindowController()

    var currentWindowController: NSWindowController?

    init() {}

    func set(windowController: NSWindowController) {
        windowController.showWindow(self)
        windowController.window?.makeKeyAndOrderFront(nil)
        currentWindowController = windowController
    }
}
