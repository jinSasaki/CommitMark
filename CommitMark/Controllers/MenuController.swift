//
//  MenuController.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

final class MenuController {

    static let shared = MenuController()

    private let markService: MarkService
    private let windowManager: WindowController
    private let applicationManager: ApplicationController
    private let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    init(markService: MarkService = .shared, windowManager: WindowController = .shared, applicationManager: ApplicationController = .shared) {
        self.markService = markService
        self.windowManager = windowManager
        self.applicationManager = applicationManager
    }

    func setup() {
        let image = NSImage(named: "icon_white_16")
        image?.isTemplate = true
        statusItem.image = image
        statusItem.highlightMode = true
        statusItem.menu = makeMenu()
    }

    func makeMenu() -> NSMenu {
        let menu = NSMenu()

        for mark in markService.marks {
            let menuItem = MarkMenuItem()
            menuItem.target = self
            menuItem.action = #selector(didSelectMarkMenuItem(_:))
            menuItem.mark = mark
            menu.addItem(menuItem)
        }

        menu.addItem(NSMenuItem.separator())

        let preferencesMenuItem = NSMenuItem()
        preferencesMenuItem.title = "Preferences"
        preferencesMenuItem.action = #selector(didSelectPreferences(_:))
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)

        let downloadMenuItem = NSMenuItem()
        downloadMenuItem.title = "About CommitMark ..."
        downloadMenuItem.action = #selector(didSelectDownloadMenuItem(_:))
        downloadMenuItem.target = self
        menu.addItem(downloadMenuItem)

        menu.addItem(NSMenuItem.separator())

        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit"
        quitMenuItem.action = #selector(didSelectQuit(_:))
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)

        return menu
    }

    @IBAction func didSelectMarkMenuItem(_ sender: MarkMenuItem) {
        guard let mark = sender.mark else { return }
        applicationManager.copyToPasteBoard(text: mark.code)
    }

    @IBAction func didSelectPreferences(_ sender: AnyObject) {
        guard let controller = Windows.preference else { return }
        windowManager.set(windowController: controller)
    }

    @IBAction func didSelectDownloadMenuItem(_ sender: AnyObject) {
        applicationManager.open(url: URL(string: "https://github.com/jinSasaki/CommitMark")!)
    }

    @IBAction func didSelectQuit(_ sender: NSButton) {
        applicationManager.terminate()
    }
}
