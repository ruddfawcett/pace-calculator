//
//  Calculator.swift
//  Pace
//
//  Created by Rudd Fawcett on 6/6/17.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Float, power: Float) -> Float {
    return Float(pow(Double(radix), Double(power)))
}

struct Time {
    var minutes: Float
    var seconds: Float
    
    public var description: String {
        var secs = seconds.roundTo(places: 1)
        if secs.isNaN {
            secs = 0.0
        }
        
        return "\(minutes.noDecimalString)m \(secs)s"
    }
    
    init(_ seconds: Float) {
        self.minutes = (seconds / 60).noDecimal
        self.seconds = seconds.truncatingRemainder(dividingBy: 60)
    }
    
    init(_ minutes: Float, _ seconds: Float) {
        self.minutes = minutes
        self.seconds = seconds
    }
    
    var totalSeconds: Float {
        return Float(minutes*60) + seconds
    }
}

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    var noDecimal: Float {
        let string = String(format: "%f", self)
        let num = string.components(separatedBy: ".").first! as NSString
        return num.floatValue
    }
    
    var noDecimalString: String {
        let string = String(format: "%f", self)
        return string.components(separatedBy: ".").first!
    }
}


class Calculator {
    // Distance = (time/split) * 500
    class func distance(split: Time, time: Time) -> Int {
        if time.totalSeconds == 0 {
            return 0
        }
        return Int((time.totalSeconds/split.totalSeconds) * 500)
    }
    
    // Split = 500 * (time/distance)
    class func split(distance: Float, time: Time) -> Time {
        let seconds = 500 * (time.totalSeconds/distance)
        return Time(seconds)
    }
    
    // Time = split * (distance/500)
    class func time(distance: Float, split: Time) -> Time {
        let seconds = split.totalSeconds * (distance/500)
        return Time(seconds)
    }
    
    // Watts = 2.8/(split/500)³
    class func watts(split: Time) -> Float {
        let cube = Float((split.totalSeconds/500) ^^ 3)
        return (2.8/(cube)).roundTo(places: 1)
    }
}
