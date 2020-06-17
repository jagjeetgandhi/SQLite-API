//
//  Database.swift
//  SQliteAPI
//
//  Created by jagjeet on 28/04/20.
//  Copyright © 2020 jagjeet. All rights reserved.
//

import Foundation
import SQLite3
class dbacces{
    
   // let dbpath:String
   // var tableName:String
    
   // init(dbpath:String,tableName:String) {
       // self.dbpath = dbpath
      //  self.tableName = tableName
   //  }
    
    var db:OpaquePointer?
    
    public   func openDatabase(dbpath:String)->OpaquePointer? {
      let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(dbpath)
        var db:OpaquePointer? = nil
      if sqlite3_open(fileURL.path, &db) != SQLITE_OK
             {
                 print("error opening database")
                 return nil
             }
             else
             {
                 print("Successfully opened connection to database at \(dbpath)")
                 return db
             }
    }
 
    func createTable(tableName:String,firstKeywillbePri columns:[String:String]) {
        func createTable() {
          var createTableStatement: OpaquePointer?
            var tablestructure:String
         
            for(col,type) in columns {
              var columnName = col
                var dtype = type
                tablestructure = tablestructure+"\(columnName) \(dtype),"
            }
            tablestructure.removeLast()
            
               let create_tableString = """
            CREATE TABLE \(tableName)(
            \(tablestructure));
            """
    
          if sqlite3_prepare_v2(db, create_tableString, -1, &createTableStatement, nil) ==
              SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
              print("\nContact table created.")
            } else {
              print("\nContact table is not created.")
            }
          } else {
            print("\nCREATE TABLE statement is not prepared.")
          }
          sqlite3_finalize(createTableStatement)
        }

    }
    
    
    func insert(tableName:String, colName:[String],data_Type:[AnyHashable:String])
    {
        var insertdata: OpaquePointer? = nil
        var colstmt:String = ""
        
        for c in colName {
            var cname = c + ","
            colstmt = colstmt + cname
           
        }
        
        colstmt.removeLast()
        var i:Int32 = 1
        var j = 0;
        let insertstatment = "INSERT INTO \(tableName)(\(colstmt)) VALUES(?,?,?);"
       
        
        if sqlite3_prepare_v2(db, insertstatment, -1, &insertdata, nil) == SQLITE_OK {
           for (d,dt) in data_Type {
                      if(dt == "String") {
                          sqlite3_bind_text(insertdata, i, (d as! NSString).utf8String, -1, nil)
                          i+=1
                      }
                      else if(dt == "Int") {
                          sqlite3_bind_int(insertdata, i, d as! Int32)
                          i+=1
                      }
                      else if(dt == "Double") {
                          sqlite3_bind_double(insertdata, i, d as! Double)
                          i+=1
                      }
                      else {
                      print("enter a valid data type from  Int , Double, String")
                      }
                  }
            
            if sqlite3_step(insertdata) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertdata)
    }
    
    
//    func read() -> [employee] {
//           let queryStatementString = "SELECT * FROM employee;"
//           var queryStatement: OpaquePointer? = nil
//           var emp: [employee] = []
//           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//               while sqlite3_step(queryStatement) == SQLITE_ROW 
//                   let id = sqlite3_column_int(queryStatement, 0)
//                   let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                   let profile = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
//                emp.append(employee(eid: Int(id), ename: name, pro: profile))
//                    print("Query Result:")
//                   print("\(id) | \(name) | \(profile)")
//               }
//           } else {
//               print("SELECT statement could not be prepared")
//           }
//           sqlite3_finalize(queryStatement)
//           return emp
//       }
    
}

