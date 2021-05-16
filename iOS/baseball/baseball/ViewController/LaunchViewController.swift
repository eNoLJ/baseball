//
//  LaunchViewController.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/14.
//
import UIKit
class LaunchViewController: UIViewController {
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 44, width: 414, height: 818))
        imageView.image = UIImage(named: "codeSquad")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
            self.animate()
        })
    }
    func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 10
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size)
        }
        UIView.animate(withDuration: 1.5) {
            self.imageView.alpha = 0
        } completion: { done in
            if done {
                self.performSegue(withIdentifier: "OAuth", sender: self)
            }
        }
    }
}
