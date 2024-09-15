//
//  ViewController.swift
//  atlysproject
//
//  Created by Mahi Garg on 14/09/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
//    private var stackView: UIStackView!
//    private var scrollView: UIScrollView!
    
    let itemCount = 3
    let maxItemWidth = 250.0;

    lazy var emptyViewWidth : CGFloat = {
        return (UIScreen.main.bounds.width - maxItemWidth) / 2
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupStackView()
        setupScrollView()
        setupInitialState()
    }
    
    fileprivate func setupStackView(){
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        addEmptyView()
        
        for i in 0..<itemCount {
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: "AE")
            
            imageView.widthAnchor.constraint(equalToConstant: maxItemWidth).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: maxItemWidth).isActive = true
            if ( i != itemCount/2){
                imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
            imageView.layer.cornerRadius = 16.0
            imageView.clipsToBounds = true
            
            stackView.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addEmptyView()
        
        let stackviewWidth = (Double(itemCount) * maxItemWidth) + (2 * emptyViewWidth)
        
        stackView.widthAnchor.constraint(equalToConstant: stackviewWidth).isActive = true
    }
    
//    private func setupStackView() {
//
//        stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        scrollView = UIScrollView()
//        scrollView.isScrollEnabled = true
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.isPagingEnabled = true
//        view.addSubview(scrollView)
//        scrollView.addSubview(stackView)
//    }
    
    fileprivate func addEmptyView() {
        let emptyView = UIView()
        emptyView.widthAnchor.constraint(equalToConstant: emptyViewWidth).isActive = true
        emptyView.heightAnchor.constraint(equalToConstant: emptyViewWidth).isActive = true
        emptyView.backgroundColor = .clear
        stackView.addArrangedSubview(emptyView)
    }
    
    fileprivate func setupScrollView(){
        scrollView.delegate = self
        scrollView.isPagingEnabled = false
    }
    
    fileprivate func setupInitialState() {
        let secondImageOffsetX = emptyViewWidth + maxItemWidth - ((scrollView.bounds.width - maxItemWidth) / 2)
        scrollView.contentOffset = CGPoint(x: secondImageOffsetX, y: 0)
        scrollViewDidScroll(scrollView)
        
        for (pos,element) in stackView.arrangedSubviews.enumerated() {
            guard let imageView = element as? UIImageView else { continue }
            
            if (pos == (itemCount / 2) + 1){
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
        }
    }
}

//MARK: ViewController + UIScrollViewDelegate
extension ViewController : UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let currentXOffset = targetContentOffset.pointee.x
        let offset = currentXOffset + scrollView.bounds.width / 2
        let closestPage = round(offset / maxItemWidth) - 1
        let newOffsetX = (closestPage * maxItemWidth) - ((scrollView.bounds.width - maxItemWidth) / 2) + emptyViewWidth
        
        targetContentOffset.pointee.x = newOffsetX
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        
        for view in stackView.arrangedSubviews {
            
            guard let imageView = view as? UIImageView else { continue }
            
            let imageViewCenterX = imageView.superview!.convert(imageView.center, to: scrollView).x
            let distanceFromCenter = abs(centerX - imageViewCenterX)
            let scaleFactor = max(0.8, 1.0 - (distanceFromCenter / scrollView.bounds.width))
            
           imageView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }
}
