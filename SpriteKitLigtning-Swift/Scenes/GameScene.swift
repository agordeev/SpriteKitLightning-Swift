//
//  GameScene.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {        
        let lightning = LightningNode(size: size)
        lightning.position = CGPointZero
        self.addChild(lightning)
    }
}
