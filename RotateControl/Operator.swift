//
//  Operator.swift
//  RotateControl
//
//  Created by z on 15/10/27.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

import Foundation
import CoreGraphics

func -(lhs:Double, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) - rhs
}

func -(lhs:CGFloat, rhs:Double) -> CGFloat {
    return lhs - CGFloat(rhs)
}

func +(lhs:Double, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) + rhs
}

func +(lhs:CGFloat, rhs:Double) -> CGFloat {
    return lhs + CGFloat(rhs)
}

func *(lhs:Double, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) * rhs
}

func *(lhs:CGFloat, rhs:Double) -> CGFloat {
    return lhs * CGFloat(rhs)
}

func /(lhs:Double, rhs:CGFloat) -> CGFloat {
    return CGFloat(lhs) / rhs
}

func /(lhs:CGFloat, rhs:Double) -> CGFloat {
    return lhs / CGFloat(rhs)
}




