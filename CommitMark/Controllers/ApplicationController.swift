//
//  ApplicationController.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

final class ApplicationController {
    static let shared = ApplicationController()

    weak var appDelegate: AppDelegate?
    init() {}

    func copyToPasteBoard(text: String) {
        let pasteBoard = NSPasteboard.general()
        pasteBoard.declareTypes([NSStringPboardType], owner: nil)
        pasteBoard.setString(text, forType: NSStringPboardType)
    }

    func open(url: URL) {
        NSWorkspace.shared().open(url)
    }

    func terminate() {
        NSApplication.shared().terminate(appDelegate)
    }
}

