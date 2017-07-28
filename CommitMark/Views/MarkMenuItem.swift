//
//  MarkMenuItem.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

final class MarkMenuItem: NSMenuItem {
    var mark: Mark? {
        didSet {
            self.title = mark?.description ?? ""
        }
    }
}
