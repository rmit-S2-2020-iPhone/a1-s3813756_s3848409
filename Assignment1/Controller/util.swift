//
//  util.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/8/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

