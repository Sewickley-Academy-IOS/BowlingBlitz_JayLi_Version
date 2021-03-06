//
//  PlayViewController.swift
//  BowlingBlitz
//
//  Created by Jason Li on 1/12/16.
//  Copyright © 2016 Jason Li. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var GameOverLabel: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var safe_zone_timer_label: UILabel!
    
    var levels = 1
    var AntX = 200
    var AntY = 703

    @IBOutlet weak var secondSafe: UILabel!
    @IBOutlet weak var firstSafe: UILabel!
    
    var bowling_balls: [BowlingBall] = []
    
    @IBOutlet weak var PlayerAnt: UIImageView!
    
    @IBOutlet weak var Ball1: BowlingBall!
    @IBOutlet weak var Ball2: BowlingBall!
    @IBOutlet weak var Ball3: BowlingBall!
    @IBOutlet weak var Ball4: BowlingBall!
    @IBOutlet weak var Ball5: BowlingBall!
    @IBOutlet weak var Ball6: BowlingBall!
    @IBOutlet weak var Ball7: BowlingBall!
    @IBOutlet weak var Ball8: BowlingBall!
    @IBOutlet weak var Ball9: BowlingBall!
    @IBOutlet weak var Ball10: BowlingBall!
    
    var GameOver = false
    
    var highestY = 703
    var in_safe_zone = false
    var score = 0
    var safe_zone_seconds_left = 5
    var TheGame = NSTimer()
    var safe_zone_timer = NSTimer()
    
    override func viewDidLoad() {

        GameOverLabel.hidden = true
        GameOverLabel.frame = CGRectMake(0, 250, 500, 100)
        
        PlayerAnt.frame = CGRectMake(200, 650, 50, 50)
        
        Ball1 = setBowlingBall(Ball1, num: 0, level: levels)
        Ball2 = setBowlingBall(Ball2, num: 1, level: levels)
        Ball3 = setBowlingBall(Ball3, num: 2, level: levels)
        Ball4 = setBowlingBall(Ball4, num: 3, level: levels)
        Ball5 = setBowlingBall(Ball5, num: 4, level: levels)
        Ball6 = setBowlingBall(Ball6, num: 6, level: levels)
        Ball7 = setBowlingBall(Ball7, num: 7, level: levels)
        Ball8 = setBowlingBall(Ball8, num: 8, level: levels)
        Ball9 = setBowlingBall(Ball9, num: 10, level: levels)
        Ball10 = setBowlingBall(Ball10, num: 11, level: levels)
        //Ball11 = setBowlingBall(Ball11, num: 12)
        bowling_balls.append(Ball1)
        bowling_balls.append(Ball2)
        bowling_balls.append(Ball3)
        bowling_balls.append(Ball4)
        bowling_balls.append(Ball5)
        bowling_balls.append(Ball6)
        bowling_balls.append(Ball7)
        bowling_balls.append(Ball8)
        bowling_balls.append(Ball9)
        bowling_balls.append(Ball10)
        //bowling_balls.append(Ball11)
        
        super.viewDidLoad()

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        PlayerAnt.center = CGPointMake(CGFloat(AntX), CGFloat(AntY))
        
        TheGame = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "PlayGame", userInfo: nil, repeats: true)

        safe_zone_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:"safeZoneCountdown", userInfo: nil, repeats: true)
        
        safe_zone_timer_label.hidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PlayGame(){
        PlayerAnt.center = CGPointMake(CGFloat(AntX), CGFloat(AntY))
        for num in 0...9{
            bowling_balls[num].Move()
            bowling_balls[num].Reset()
            if (bowling_balls[num].Intersections(PlayerAnt) == true){
                EndGame()
            }
        }
        secondSafe.frame = CGRectMake(-40,250,550,50)
        firstSafe.frame = CGRectMake(-40,450,550,50)
        
        scoreLabel.text = "Score: \(score)"
        
        if(((AntY > 289) && (AntY < 342)) || ((AntY > 513) && (AntY < 570)))
        {
            in_safe_zone = true
        }
        else{
            in_safe_zone = false
            safe_zone_timer_label.hidden = true
            safe_zone_seconds_left = 5
        }
    }
    
    
    func safeZoneCountdown(){
        if(in_safe_zone){
            safe_zone_timer_label.hidden = false;
            safe_zone_timer_label.text = "\(safe_zone_seconds_left)"
            safe_zone_seconds_left--;
            
            if(safe_zone_seconds_left < 0){
                safe_zone_timer.invalidate();
                GameOver = false
                EndGame()
            }
        }
    }
    
    
    func EndGame (){
        TheGame.invalidate()
        GameOverLabel.frame = CGRectMake(0, 250, 500, 100)
        safe_zone_timer_label.hidden = true
        for num in 0...9{
            bowling_balls[num].hidden = true
        }
        
        PlayerAnt.hidden = true
        secondSafe.hidden = true
        firstSafe.hidden = true
        GameOverLabel.frame = CGRectMake(0, 250, 500, 100)
        
        if (GameOver){
            GameOverLabel.setTitle("You Win", forState: UIControlState.Normal);
            GameOverLabel.backgroundColor = UIColor.greenColor()
            GameOverLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            GameOverLabel.hidden = false
        }
        else{
            GameOverLabel.setTitle("Game Over", forState: UIControlState.Normal);            GameOverLabel.backgroundColor = UIColor.redColor()
            GameOverLabel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            GameOverLabel.hidden = false
        }
        
        GameOverLabel.frame = CGRectMake(0, 250, 500, 100)
    }
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left){
            AntX -= 50
            if (AntX < 0){
                AntX += 50
            }
        }
        if (sender.direction == .Right){
            AntX += 50
            if (AntX > 370){
                AntX -= 50
            }
        }
        if (sender.direction == .Up){
            AntY -= 56
            if (AntY < -0){
                GameOver = false
                GameReset()
            }
            if(AntY < highestY){
                score += 10
            }
        }
        if (sender.direction == .Down){
            AntY += 57
            if (AntY > 750){
                AntY -= 56
            }
            score -= 10
        }
        print("X: \(AntX) Y: \(AntY) \n")
    }
    func setBowlingBall (ball: BowlingBall, num: Int, level: Int) -> BowlingBall{
        ball.center.x = -50
        ball.center.y = CGFloat((num * 57))
        ball.frame = CGRectMake(ball.center.x,ball.center.y,50,50)
        ball.sp = Int(arc4random_uniform(7)) + level
        return ball
    }
    
    func GameReset (){
        AntY = 703
        AntX = 200
        levels++
        var cnt = 0
        for num in 0...9{
            bowling_balls[num] = setBowlingBall(bowling_balls[num], num: cnt, level: levels)
            cnt++
            if (cnt == 5 || cnt == 9){
                cnt++
            }
        }
        print(levels)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
