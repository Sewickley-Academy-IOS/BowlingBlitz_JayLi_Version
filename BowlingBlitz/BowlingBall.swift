//
//  BowlingBall.swift
//  BowlingBlitz
//
//  Created by Jason Li on 1/29/16.
//  Copyright © 2016 Jason Li. All rights reserved.
//

import UIKit

class BowlingBall: UIImageView{
    
    var sp: Int {
        get{
            return self.sp
        }
        set {
            speeds = newValue / 2
        }
        
    }
    var speeds: Int = 0
    init (Speed: Int){
        let ball = UIImage (named: "Bowling Ball")
        super.init(image: ball)
        sp = Speed
    }

    required init?(coder aDecoder: NSCoder) {
        let ball = UIImage (named: "Bowling Ball")
        super.init(image: ball)
    }

    func Move (){
        let ballx = self.center.x
        let bally = self.center.y
        self.center = CGPointMake(ballx + CGFloat(speeds), bally)
        self.Reset()
    }
    func Reset (){
        if (self.center.x > 500){
            self.center.x = CGFloat(-1 * Int(arc4random_uniform(200) + 50))
            speeds = Int(arc4random_uniform(8) + 4) / 2
        }
    }
    func Intersections (ant: UIImageView) -> Bool{
        if (CGRectIntersectsRect(ant.frame, self.frame)){
            return true
        }else{
            return false
        }
    }
}