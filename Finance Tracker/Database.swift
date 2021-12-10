//
//  Database.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 29.11.21.
//

import Foundation
import SwiftUI
import SQLite

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month],from: Calendar.current.startOfDay(for: self)
            )
        )!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(
            byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()
        )!
    }
}


extension Transaction {
    init(row: Row) {
        do {
            try self.id = row.get(Expression<String>("id"))
            try self.amount = row.get(Expression<Double>("amount"))
            try self.name = row.get(Expression<String>("name"))
            try self.category = row.get(Expression<String>("category"))
            try self.dateandtime = row.get(Expression<Date>("dateandtime"))
            try self.repeattag = row.get(Expression<Int>("repeattag"))
            try self.endrepeat = row.get(Expression<Bool>("endrepeat"))
            try self.repeatenddate = row.get(Expression<Date>("repeatenddate"))
        } catch {
            self.id = ""
            self.amount = 0.0
            self.name = ""
            self.category = ""
            self.dateandtime = Date.now
            self.repeattag = 0
            self.endrepeat = false
            self.repeatenddate = Date.now
        }
    }
}


class Database {
    @EnvironmentObject var data: Data
    
    var db: Connection!
    
    let transactionTable = Table("transactions")
    
    let id = Expression<String>("id")
    let amount = Expression<Double>("amount")
    let name = Expression<String>("name")
    let category = Expression<String>("category")
    let dateandtime = Expression<Date>("dateandtime")
    let repeattag = Expression<Int>("repeattag")
    let endrepeat = Expression<Bool>("endrepeat")
    let repeatenddate = Expression<Date>("repeatenddate")
    
    let nameTable = Table("names")
    
    let categoryTable = Table("categories")
    
    let minusCategory = Expression<String>("minusCategory")
    let plusCategory = Expression<String>("plusCategory")
    
    func connectToDatabase() {
        do {
            debugPrint("sucess")
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let db = try Connection(path.appendingPathComponent("database").appendingPathExtension("sqlite3").absoluteString)
            self.db = db
        } catch {
            print(error)
        }
    }
    
    func createTables() {
        let createTransactionTable = transactionTable.create(ifNotExists: true) { table in
            table.column(id)
            table.column(amount)
            table.column(name)
            table.column(category)
            table.column(dateandtime)
            table.column(repeattag)
            table.column(endrepeat)
            table.column(repeatenddate)
        }
            
        let createNameTable = nameTable.create(ifNotExists: true) { table in
            table.column(name)
        }
        
        let createCategoryTable = categoryTable.create(ifNotExists: true) { table in
            table.column(minusCategory)
            table.column(plusCategory)
//            insertDefaultCategories(categoriesMinus: data.categoriesminus)
        }
        
        do {
            try db.run(createTransactionTable)
            try db.run(createNameTable)
            try db.run(createCategoryTable)
        } catch {
            print(error)
        }
    }
    
//    func insertDefaultCategories(categoriesMinus: [String]) {
//        let insertCategories = categoryTable.insertMany(
//
//        )
//
//        do {
//            try db.run(insertCategories)
//        } catch {
//            print(error)
//        }
//    }
    
    func insertTransaction(transaction: Transaction) {
        let insert = transactionTable.insert(
            id <- transaction.id,
            amount <- transaction.amount,
            name <- transaction.name,
            category <- transaction.category,
            dateandtime <- transaction.dateandtime,
            repeattag <- transaction.repeattag,
            endrepeat <- transaction.endrepeat,
            repeatenddate <- transaction.repeatenddate
        )
        
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func loadAllTransactions() -> [Transaction]  {
        var transactions: [Transaction] = []
        do {
            let transactionsRow = Array(try db.prepare(transactionTable))
            for transaction in transactionsRow {
                let test = Transaction.init(row: transaction)
                transactions.append(test)
            }
        } catch {
            print(error)
        }
        return transactions
    }
    
//    func loadAmountsforCurrentMonth() -> [Transaction] {
//        do {
//            let transactionAmounts = Array(try db.prepare(transactionTable
//                                                            .select(amount)
//                                                            .filter(Date().startOfMonth()...Date().endOfMonth() ~= dateandtime)
//                                                         ))
//            return transactionAmounts
//        } catch {
//            print(error)
//        }
//    }
}
