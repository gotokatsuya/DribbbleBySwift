//
//  ItemController.swift
//  DribbbleBySwift
//
//  Created by KatsuyaGoto on 2014/06/11.
//  Copyright (c) 2014年 KatsuyaGoto. All rights reserved.
//



/******************
 * Unused class!! *
 ******************/


import Foundation

protocol SuccessProtocol{
    func onSuccess(results: AnyObject!);
}


class ItemController {
    
    var delegate: SuccessProtocol?
    
    init(delegate: SuccessProtocol?) {
        self.delegate = delegate
    }
    
    enum SearchType{
        case DEBUTS,POPULAR,EVERYONE
        func description () -> String {
            switch self {
            case DEBUTS:
                return "debuts"
            case POPULAR:
                return "popular"
            case EVERYONE:
                return "everyone"
            }
        }
    }
}