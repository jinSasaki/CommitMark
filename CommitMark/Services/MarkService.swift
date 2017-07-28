//
//  MarkService.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Cocoa

protocol KeyValueAccessable {
    func array(forKey: String) -> [Any]?
    func set(_ value: Any?, forKey: String)
    @discardableResult
    func synchronize() -> Bool
}

extension UserDefaults: KeyValueAccessable {}

final class MarkService {
    typealias ObserveBlock = (_ marks: [Mark]) -> Void

    static let shared = MarkService()
    private static var defaultMarks: [Mark] {
        return[
            Mark(code: ":heavy_plus_sign:", description: "➕ 機能を追加したとき"),
            Mark(code: ":wrench:", description: "🔧 仕様を変更したとき"),
            Mark(code: ":art:", description: "🎨 コードの可読性や保守性を改善したとき"),
            Mark(code: ":racehorse:", description: "🐎 パフォーマンスを改善したとき"),
            Mark(code: ":bug:", description: "🐛 バグを修正したとき"),
            Mark(code: ":arrow_up:", description: "🔼 バージョンを上げたとき"),
            Mark(code: ":arrow_down:", description: "🔽 バージョンを下げたとき"),
            Mark(code: ":bird:", description: "🐦 Swift化をしたとき"),
            Mark(code: ":fire:", description: "🔥 コードやファイルを削除したとき"),
            Mark(code: ":package:", description: "📦 ファイルを移動したとき"),
            Mark(code: ":shirt:", description: "👕 warningを取り除いた時"),
            Mark(code: ":white_check_mark:", description: "✅ テストを追加・編集したとき"),
            Mark(code: ":memo:", description: "📝 ドキュメントを書いたとき"),
            Mark(code: ":ok:", description: "🆗 なにかOKな変更をしたとき")
        ]
    }

    let userDefaults: KeyValueAccessable
    private var observerBlocks: [String: ObserveBlock] = [:]

    var marks: [Mark] {
        get {
            let markValues = self.userDefaults.array(forKey: Mark.Key.marks) as? [[String: String]] ?? []
            return markValues.map({ Mark(dictionary: $0) })
        }
        set {
            userDefaults.set(newValue.map({ $0.toDictionary() }), forKey: Mark.Key.marks)
            userDefaults.synchronize()

            // Notify to block
            observerBlocks.forEach({ $0.value(newValue) })
        }
    }

    init(userDefaults: KeyValueAccessable = UserDefaults.standard) {
        self.userDefaults = userDefaults

        // Set default if not initialized
        if userDefaults.array(forKey: Mark.Key.marks) == nil {
            setDefault()
        }
    }

    func setDefault() {
        marks = MarkService.defaultMarks
    }

    func register(observerBlock: @escaping ObserveBlock) -> String {
        let id = UUID().uuidString
        observerBlocks[id] = observerBlock
        return id
    }

    func unregisterObserverBlock(id: String) {
        observerBlocks.removeValue(forKey: id)
    }
}

