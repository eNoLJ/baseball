//
//  GameView.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/04.
//

import UIKit

class GameView: UIView {
    private var baseLayer = CAShapeLayer()
    private var baseLineLayer = CAShapeLayer()
    private var playerlayers: [CALayer] = []
    private lazy var centerX = CGFloat(bounds.size.width/2)
    private lazy var centerY = CGFloat(bounds.size.height/2)
    private lazy var firstBasePosition = CGPoint(x: centerX+100, y: centerY)
    private lazy var secondBasePosition = CGPoint(x: centerX, y: centerY-100)
    private lazy var thirdBasePosition = CGPoint(x: centerX-100, y: centerY)
    private lazy var homeBasePosition = CGPoint(x: centerX, y: centerY+100)
    private lazy var firstBaseAnimation: CABasicAnimation = {
       let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: centerX, y: centerY+100)
        animation.toValue = CGPoint(x: centerX+100, y: centerY)
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }()
    private lazy var secondBaseAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: centerX+100, y: centerY)
        animation.toValue = CGPoint(x: centerX, y: centerY-100)
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }()
    private lazy var thirdBaseAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: centerX, y: centerY-100)
        animation.toValue = CGPoint(x: centerX-100, y: centerY)
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }()
    private lazy var homeBaseAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: centerX-100, y: centerY)
        animation.toValue = CGPoint(x: centerX, y: centerY+100)
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBaseLineLayer()
        setUpBaseLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpBaseLineLayer()
        setUpBaseLayer()
    }
    
    func setUpBaseLayer() {
        let path = UIBezierPath()
        
        //홈베이스
        path.move(to: CGPoint(x: centerX+10, y: centerY+110))
        path.addLine(to: CGPoint(x: centerX+10, y: centerY+100))
        path.addLine(to: CGPoint(x: centerX, y: centerY+90))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY+100))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY+110))
        path.close()
        
        // 1루
        path.move(to: CGPoint(x: centerX+110, y: centerY))
        path.addLine(to: CGPoint(x: centerX+100, y: centerY-10))
        path.addLine(to: CGPoint(x: centerX+90, y: centerY))
        path.addLine(to: CGPoint(x: centerX+100, y: centerY+10))
        path.close()
        
        // 2루
        path.move(to: CGPoint(x: centerX, y: centerY-90))
        path.addLine(to: CGPoint(x: centerX+10, y: centerY-100))
        path.addLine(to: CGPoint(x: centerX, y: centerY-110))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY-100))
        path.close()
        
        // 3루
        path.move(to: CGPoint(x: centerX-110, y: centerY))
        path.addLine(to: CGPoint(x: centerX-100, y: centerY+10))
        path.addLine(to: CGPoint(x: centerX-90, y: centerY))
        path.addLine(to: CGPoint(x: centerX-100, y: centerY-10))
        path.close()
        
        baseLayer.frame = self.bounds
        baseLayer.path = path.cgPath
        baseLayer.fillColor = UIColor.systemBackground.cgColor
        baseLayer.strokeColor = UIColor.gray.cgColor
        baseLayer.lineWidth = 1
        self.layer.addSublayer(baseLayer)
    }
    
    func setUpBaseLineLayer() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: centerX, y: centerY+100))
        path.addLine(to: CGPoint(x: centerX+100, y: centerY))
        path.addLine(to: CGPoint(x: centerX, y: centerY-100))
        path.addLine(to: CGPoint(x: centerX-100, y: centerY))
        path.close()
        
        baseLineLayer.frame = self.bounds
        baseLineLayer.path = path.cgPath
        baseLineLayer.lineWidth = 2
        baseLineLayer.fillColor = .none
        baseLineLayer.strokeColor = UIColor.gray.cgColor
        self.layer.addSublayer(baseLineLayer)
    }
    
    func setPlayerLayer(firstBase: Bool, secondBase: Bool, thirdBase: Bool) {
        if firstBase == true {
            makePlayerLayer(position: firstBasePosition)
        }
        if secondBase == true {
            makePlayerLayer(position: secondBasePosition)
        }
        if thirdBase == true {
            makePlayerLayer(position: thirdBasePosition)
        }
    }
    
    func makePlayerLayer(position: CGPoint? = nil) {
        let layer = CALayer()
        self.playerlayers.append(layer)
        let playerImage = UIImage.init(systemName: "figure.walk")?.cgImage
        layer.frame = CGRect(x: centerX-15, y: centerY+85, width: 30, height: 30)
        layer.contents = playerImage
        if let position = position {
            layer.position = position
        }
        
        self.layer.addSublayer(layer)
    }
    
    func hit() {
        makePlayerLayer()
        playerlayers.forEach { layer in
            CATransaction.begin()
            switch layer.position {
            case homeBasePosition:
                CATransaction.setCompletionBlock {
                    layer.position = self.firstBasePosition
                }
                layer.add(firstBaseAnimation, forKey: "toFirst")
            case firstBasePosition:
                CATransaction.setCompletionBlock {
                    layer.position = self.secondBasePosition
                }
                layer.add(secondBaseAnimation, forKey: "toSecond")
            case secondBasePosition:
                CATransaction.setCompletionBlock {
                    layer.position = self.thirdBasePosition
                }
                layer.add(thirdBaseAnimation, forKey: "toThird")
            case thirdBasePosition:
                CATransaction.setCompletionBlock {
                    layer.removeFromSuperlayer()
                }
                layer.add(homeBaseAnimation, forKey: "toHome")
            default:
                break
            }
            CATransaction.commit()
        }
    }
}
