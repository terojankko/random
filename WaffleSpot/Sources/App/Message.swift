//
//  Message.swift
//  App
//
//  Created by Tero Jankko on 3/21/19.
//

import Foundation
import Vapor
import FluentSQLite

struct Message: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var username: String
    var content: String
    var date: Date
}
