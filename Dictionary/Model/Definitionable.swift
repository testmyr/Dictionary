//
//  Definitionable.swift
//  Dictionary
//
//  Created by sdk on 27.02.2024.
//

import Foundation

protocol Definitionable {
    var definitions: [Definition] { get set }
    var text: String { get }
}
