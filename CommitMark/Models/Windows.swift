//
//  Windows.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

struct Windows {
    static var preference: NSWindowController? {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateController(withIdentifier: "Window") as? NSWindowController
    }
}
