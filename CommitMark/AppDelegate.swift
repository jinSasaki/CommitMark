//
//  AppDelegate.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2016/03/10.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ApplicationController.shared.appDelegate = self
        MenuController.shared.setup()
    }
}
