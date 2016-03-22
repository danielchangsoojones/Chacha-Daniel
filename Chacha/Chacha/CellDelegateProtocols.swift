//
//  CellDelegateProtocols.swift
//  Chacha
//
//  Created by Daniel Jones on 3/9/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation

protocol ActivityTableViewCellDelegate {
    func updateLike(likeCountTag: Int, isQuestion: Bool)
}

protocol QuestionTableViewCellDelegate {
    func createAnswer(answer: String)
}