//
//  MainViewController.swift
//  HeroesAvanzado
//
//  Created by Gerardo Paxtian on 14/02/23.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    private var sideMenuTraililngConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    
    private var sideMenuShadowView: UIView!
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        
        let panGerstureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGerstureRecognizer.delegate = self
        view.addGestureRecognizer(panGerstureRecognizer)
        
        self.sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0
        self.sideMenuViewController.delegate = self
        
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTraililngConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTraililngConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
    
        ])
        
        showViewController(viewController: UINavigationController.self, storyboardId: "HeroesNavID")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTraililngConstraint.constant = self.isExpanded ? 0 :
                (-self.sideMenuRevealWidth - self.paddingForRotation)
            }

        }
    }
}

extension MainViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "HeroesNavID")
        case 1:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "MapNavID")
        case 2:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "LoginNavID")
        case 3:
            self.showViewController(viewController: UINavigationController.self, storyboardId: "ToolsNavID")
            
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.sideMenuState(expanded: false)
        }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        viewController.view.tag = 99
        
        view.insertSubview(viewController.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(viewController)
        
        DispatchQueue.main.async {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
        
        if !self.revealSideMenuOnTop {
            if isExpanded {
                viewController.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                viewController.view.addSubview(self.sideMenuShadowView)
            }
        }
        viewController.didMove(toParent: self)
        
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            UIView.animate(withDuration: 0.5) {self.sideMenuShadowView.alpha = 0.6}
        } else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            UIView.animate(withDuration: 0.5) {self.sideMenuShadowView.alpha = 0.0}
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTraililngConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            } else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension UIViewController {
    
    func revealViewController() -> MainViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is MainViewController {
            return viewController! as? MainViewController
        }
        
        while (!(viewController is MainViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is MainViewController {
            return viewController as? MainViewController
        }
        return nil
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer){
        let position:CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x
        
        switch sender.state {
        case .began:
            if velocity > 0, !self.isExpanded {
                sender.state = .cancelled
            }
            
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            } else {
                if velocity < 0, self.isExpanded {
                    self.draggingIsEnabled = false
                }
            }
            
            if self.draggingIsEnabled {
                
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }
            }
            
            if self.revealSideMenuOnTop {
                self.panBaseLocation = 0.0
                if self.isExpanded {
                    self.panBaseLocation = self.sideMenuRevealWidth
                }
            }
        case .changed:
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTraililngConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
            } else {
                if let recogView = sender.view?.subviews[1] {
                    
                    let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha
                    
                    if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                        recogView.frame.origin.x = recogView.frame.origin.x + position
                        sender.setTranslation(CGPoint.zero, in: view)
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTraililngConstraint.constant > -( self.sideMenuRevealWidth * 0.5 )
                self.sideMenuState(expanded: movedMoreThanHalf)
            } else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
        
    }
}
    
