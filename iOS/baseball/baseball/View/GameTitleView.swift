//
//  MaskedLabelView.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/13.
//

import UIKit

class GameTitleView: UIView {

    weak var label: UILabel!
    var startColor: UIColor = .blue
    var endColor: UIColor = .black
    var duration: CFTimeInterval = 2.0
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor,
        ]

        gradientLayer.locations = [
            0.0,
            0.1
            ] as [NSNumber]

        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        let lbl = UILabel(frame: frame)
        lbl.numberOfLines = 0
        mask = lbl
        label = lbl
        label.textAlignment = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = frame
        gradientLayer.frame = frame
    }

    func animate() {
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor,
        ]
        gradientLayer.removeFromSuperlayer()
        layer.addSublayer(gradientLayer)

        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [0.0, 0.1]
        anim.toValue = [1.0, 1.0]
        anim.duration = duration
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        gradientLayer.removeAllAnimations()
        gradientLayer.add(anim, forKey: nil)
    }

}
