//
//  LightningBoltNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

var kLoadSharedAssetsOnceToken: dispatch_once_t = 0

var sHalfCircle = SKTexture()
var sLightningSegment = SKTexture()
var sSoundActions = Array<SKAction>()

class LightningBoltNode: SKNode {
    
    var lifetime = 0.15
    var lineDrawDelay = 0.02
    var displaceCoefficient = 0.25
    var lineRangeCoefficient = 1.8
    var pathArray = Array<CGPoint>()
    
    init(startPoint: CGPoint, endPoint: CGPoint, lifetime: Double, lineDrawDelay: Double, displaceCoefficient: Double, lineRangeCoefficient: Double) {
        super.init()
        self.lifetime = lifetime
        self.lineDrawDelay = lineDrawDelay
        self.displaceCoefficient = displaceCoefficient
        self.lineRangeCoefficient = lineRangeCoefficient
        self.drawBolt(startPoint, endPoint: endPoint)
        let soundAction = sSoundActions[Int(arc4random_uniform(UInt32(sSoundActions.count)))]
        self.runAction(soundAction)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Drawing bolt
    
    func drawBolt(startPoint: CGPoint, endPoint: CGPoint) {
        // Dynamically calculating displace
        let xRange = endPoint.x - startPoint.x
        let yRange = endPoint.y - startPoint.y
        let hypot = hypotf(fabsf(Float(xRange)), fabsf(Float(yRange)))
        // hypot/displace = 4/1
        let displace = hypot*Float(self.displaceCoefficient)
        
        pathArray.append(startPoint)
        self.createBolt(startPoint.x, y1: startPoint.y, x2: endPoint.x, y2: endPoint.y, displace: Double(displace))
        
        for var i = 0; i < pathArray.count - 1; i++ {
            self.addLineToBolt(pathArray[i], endPoint: pathArray[i+1], delay: Double(i)*self.lineDrawDelay)
        }
        
        let waitDuration = Double(pathArray.count - 1)*self.lineDrawDelay + self.lifetime
        let disappear = SKAction.sequence([SKAction.waitForDuration(waitDuration), SKAction.fadeOutWithDuration(0.25), SKAction.removeFromParent()])
        self.runAction(disappear)
    }
    
    func addLineToBolt(startPoint: CGPoint, endPoint: CGPoint, delay: Double) {
        let line = LightningLineNode(startPoint: startPoint, endPoint: endPoint)
        self.addChild(line)
        if (delay == 0) {
            line.draw()
        }
        else {
            let delayAction = SKAction.waitForDuration(NSTimeInterval(delay))
            let draw = SKAction.runBlock({ () -> Void in
                line.draw()
            })
            line.runAction(SKAction.sequence([delayAction,draw]))
        }
    }
    
    func createBolt(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, displace: Double) {
        if displace < self.lineRangeCoefficient {
            let point = CGPointMake(x2, y2);
            self.pathArray.append(point)
        }
        else {
            var mid_x = Double(x2+x1)*0.5;
            var mid_y = Double(y2+y1)*0.5;
            mid_x += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            mid_y += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            let halfDisplace = displace*0.5
            self.createBolt(x1, y1: y1, x2: CGFloat(mid_x), y2: CGFloat(mid_y), displace: halfDisplace)
            self.createBolt(CGFloat(mid_x), y1: CGFloat(mid_y), x2: x2, y2: y2, displace: halfDisplace)
        }
    }
    
    // MARK: Shared assets
    
    class func loadSharedAssets() {
        dispatch_once(&kLoadSharedAssetsOnceToken) {
            sHalfCircle = SKTexture(imageNamed: "half_circle")
            sLightningSegment = SKTexture(imageNamed: "lightning_segment")
            for var i = 1; i <= 6; i++ {
                let soundFileName = "shock\(i).aiff"
                let soundAction = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
                sSoundActions.append(soundAction)
            }
        }
    }
    
}