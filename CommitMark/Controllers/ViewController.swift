//
//  ViewController.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2016/03/10.
//
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var versionText: NSTextField!
    @IBOutlet private weak var launchCheckBox: NSButton!

    var markService: MarkService = .shared

    fileprivate var editingColumn: NSTableColumn?
    private var observerId: String?

    deinit {
        guard let id = observerId else { return }
        markService.unregisterObserverBlock(id: id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSApp.activate(ignoringOtherApps: true)

        tableView.dataSource = self
        tableView.delegate = self
        versionText.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

        observerId = markService.register { [weak self] (marks) in
            self?.tableView.reloadData()
        }
    }

    override func keyDown(with theEvent: NSEvent) {
        let key = theEvent.charactersIgnoringModifiers
        if key == String(describing: UnicodeScalar(NSDeleteCharacter)!) && self.tableView.selectedRow != -1 {
            NSApp.sendAction(#selector(delete), to: self, from: self)
        } else {
            super.keyUp(with: theEvent)
        }
    }

    func delete() {
        markService.marks.remove(at: self.tableView.selectedRow)
    }

    // MARK: - IBActions

    @IBAction func didTapAdd(_ sender: AnyObject) {
        markService.marks.append(Mark())
        tableView.scrollRowToVisible(markService.marks.count - 1)
    }

    @IBAction func didTapDefault(_ sender: AnyObject) {
        markService.setDefault()
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return markService.marks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn = tableColumn else { return nil }
        let mark = markService.marks[row]
        switch tableColumn.identifier {
        case "code":
            return mark.code
        case "description":
            return mark.description
        default:
            return nil
        }
    }
}

extension ViewController: NSTableViewDelegate {
    override func controlTextDidEndEditing(_ obj: Notification) {
        guard let tableView = obj.object as? NSTableView else { return }
        guard let textView = obj.userInfo?["NSFieldEditor"] else { return }
        guard let tableColumn = self.editingColumn else { return }

        switch tableColumn.identifier {
        case "code":
            markService.marks[tableView.selectedRow].code = (textView as? NSTextView)?.string ?? ""
        case "description":
            markService.marks[tableView.selectedRow].description = (textView as? NSTextView)?.string ?? ""
        default:
            break
        }
        self.editingColumn = nil
    }

    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        self.editingColumn = tableColumn
        return true
    }
}
