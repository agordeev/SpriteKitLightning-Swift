//
//  LightningLineNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

class LightningLineNode: SKNode {
    var startPoint = CGPointMake(0.0, 0.0)
    var endPoint = CGPointMake(0.0, 0.0)
    let thickness = 1.3
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        super.init()
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() {
        let imageThickness = 2.0
        let thicknessScale = CGFloat(self.thickness / imageThickness)
        let startPointInThisNode = self.convertPoint(self.startPoint, fromNode: self.parent!)
        let endPointInThisNode = self.convertPoint(self.endPoint, fromNode: self.parent!)
        
        let angle = CGFloat(atan2(Float(endPointInThisNode.y) - Float(startPointInThisNode.y),
            Float(endPointInThisNode.x) - Float(startPointInThisNode.x)));
        let length = hypotf(fabsf(Float(endPointInThisNode.x) - Float(startPointInThisNode.x)),
            fabsf(Float(endPointInThisNode.y) - Float(startPointInThisNode.y)))
        
        let halfCircleA = SKSpriteNode(texture: sHalfCircle)
        halfCircleA.anchorPoint = CGPointMake(1, 0.5)
        let halfCircleB = SKSpriteNode(texture: sHalfCircle)
        halfCircleB.anchorPoint = CGPointMake(1, 0.5)
        halfCircleB.xScale = -1.0
        let lightningSegment = SKSpriteNode(texture: sLightningSegment)
        halfCircleA.yScale = thicknessScale
        halfCircleB.yScale = thicknessScale
        lightningSegment.yScale = thicknessScale
        halfCircleA.zRotation = angle
        halfCircleB.zRotation = angle
        lightningSegment.zRotation = angle
        lightningSegment.xScale = CGFloat(length*Float(2))
        
        //    halfCircleA.alpha = halfCircleB.alpha = 0.8f;
        halfCircleA.blendMode = SKBlendMode.Alpha
        halfCircleB.blendMode = SKBlendMode.Alpha
        lightningSegment.blendMode = SKBlendMode.Alpha
        
        halfCircleA.position = startPointInThisNode
        halfCircleB.position = endPointInThisNode
        lightningSegment.position = CGPointMake((startPointInThisNode.x + endPointInThisNode.x)*0.5, (startPointInThisNode.y + endPointInThisNode.y)*0.5)
        self.addChild(halfCircleA)
        self.addChild(halfCircleB)
        self.addChild(lightningSegment)
    }
}
