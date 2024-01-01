//
//  ViewController.swift
//  ElisoftTest
//
//  Created by Quan on 28/12/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    
    @IBOutlet weak var pulseView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        animateLogoOnAppear(imageView: appLogo) { [weak self] in
            self?.animatePlayButtonOnAppear(view: self!.pulseView, onComplete: {
            })
            self?.animatePlayButtonOnAppear(view: self!.playButton) { [weak self] in
                self?.startPulseAnimation(view: self!.pulseView)
            }
        }
    }
    
    private func configUI() {
        pulseView.layer.cornerRadius = pulseView.frame.width / 2
        pulseView.transform = CGAffineTransform(scaleX: 0, y: 0)
        playButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startApp))
        playButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func startApp() {
        let springBoardViewController: SpringBoardViewController = SpringBoardViewController(nibName: "SpringBoardViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: springBoardViewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)

    }
}

// MARK: Animation
extension ViewController {
    func animateLogoOnAppear(imageView: UIImageView, onComplete: @escaping () -> Void) {
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseInOut, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                imageView.transform = .identity
            }) { _ in
                onComplete()
            }
        })
    }
    
    func animatePlayButtonOnAppear(view: UIView, onComplete: @escaping () -> Void) {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut, animations: {
            view.transform = .identity
        }) { _ in
            onComplete()
        }
    }
    
    func animateImageDisappear(imageView: UIImageView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            imageView.alpha = 0.0
        }, completion: { _ in
            imageView.removeFromSuperview() // Optionally remove the image from the view hierarchy
        })
    }
    
    
    func startPulseAnimation(view: UIView) {
        var numberOfPulse: Int = 0;
        let maxNumberOfPulse: Int = 1;
        let numberOfRunningPulse = view.layer.sublayers?.filter({ $0 is PulseAnimation }).count ?? 0
        guard numberOfRunningPulse == 0 else { return }
        numberOfPulse += 1
        view.layer.insertSublayer(initPulseAnimationLayer(), below: view.layer)
        if(numberOfPulse < maxNumberOfPulse) {
            insertPulseLayer()
        }
        
        func initPulseAnimationLayer() -> PulseAnimation {
            let pulse = PulseAnimation(numberOfPulse: Float.infinity,
                                       radius: (view.frame.size.height * 0.5),
                                       postion: CGPoint(x: view.bounds.size.width / 2 , y: view.bounds.height / 2),
                                       animationDuration: 2)
            pulse.animationDuration = 2.0
            pulse.backgroundColor = UIColor.red.cgColor
            return pulse;
        }
        
        func insertPulseLayer() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                numberOfPulse += 1
                view.layer.insertSublayer(initPulseAnimationLayer(), below: view.layer)
                if(numberOfPulse < maxNumberOfPulse) {
                    insertPulseLayer()
                }
            }
        }
    }
}

