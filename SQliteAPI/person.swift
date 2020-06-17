//
//  person.swift
//  SQliteAPI
//
//  Created by jagjeet on 28/04/20.
//  Copyright © 2020 jagjeet. All rights reserved.
//

import Foundation

class employee {
    var name:String
    var id:Int
    var profile:String
    
    init(eid:Int,ename:String,pro:String) {
        name=ename;
        id=eid;
        profile=pro
    }
}
