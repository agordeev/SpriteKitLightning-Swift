//
//  LightningNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

class LightningNode: SKSpriteNode {
    
    var targetPoints = [CGPoint]();
    
    // Time between bolts (in seconds)
    let timeBetweenBolts = 0.15
    
    // Bolt lifetime (in seconds)
    let boltLifetime = 0.1
    
    // Line draw delay (in seconds). Set as 0 if you want whole bolt to draw instantly
    let lineDrawDelay = 0.00175
    
    // 0.0 - the bolt will be a straight line. >1.0 - the bolt will look unnatural
    let displaceCoefficient = 0.25
    
    // Make bigger if you want bigger line lenght and vice versa
    let lineRangeCoefficient = 1.8
    
    // MARK: - Life cycle
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        LightningBoltNode.loadSharedAssets()
        self.userInteractionEnabled = true
        self.anchorPoint = CGPoint.zero
        self.size = size
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let locationInNode = touch.locationInNode(self)
        
        self.targetPoints.removeAll(keepCapacity: false)
        self.targetPoints.append(locationInNode)
        self.startLightning()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let locationInNode = touch.locationInNode(self)
        
        self.targetPoints.removeAll(keepCapacity: false)
        self.targetPoints.append(locationInNode)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.stopLightning()
    }
    
    // MARK: Lightning operating
    
    func startLightning() {
        let wait = SKAction.waitForDuration(timeBetweenBolts)
        let addLightning = SKAction.runBlock { () -> Void in
            let startPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            for targetPoint in self.targetPoints {
                self.addBolt(startPoint, endPoint: targetPoint)
            }
        }
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([addLightning, wait])), withKey: "lightning")
    }
    
    func stopLightning() {
        self.removeActionForKey("lightning")
    }
    
    func addBolt(startPoint: CGPoint, endPoint: CGPoint) {
        let bolt = LightningBoltNode(startPoint: startPoint, endPoint: endPoint, lifetime: self.boltLifetime, lineDrawDelay: self.lineDrawDelay, displaceCoefficient: self.displaceCoefficient, lineRangeCoefficient: self.lineRangeCoefficient)
        self.addChild(bolt)
    }
}