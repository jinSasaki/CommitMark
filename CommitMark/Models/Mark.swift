//
//  Mark.swift
//  CommitMark
//
//  Created by Jin Sasaki on 2017/07/28.
//
//

import Foundation

struct Mark {
    struct Key {
        static let code = "code"
        static let description = "description"
        static let marks = "marks"
    }

    var code: String = ""
    var description: String = ""

    init(code: String = ":ok:", description: String = "🆗 Some description") {
        self.code = code
        self.description = description
    }

    init(dictionary: [String: String]) {
        self.code = dictionary[Mark.Key.code] ?? ""
        self.description = dictionary[Mark.Key.description] ?? ""
    }

    func toDictionary() -> [String: String] {
        return [
            Mark.Key.code: self.code,
            Mark.Key.description: self.description
        ]
    }
}

