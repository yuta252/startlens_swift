//
//  IntroAnimationViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/24.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Lottie

class IntroAnimationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var skipText: UIButton!
    
    var onboardArray = ["test", "test", "test"]
    var onboardStringArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scrollView.isPagingEnabled = true
        setUpScroll()

        for i in 0...2{
            let animationView = AnimationView()
            let animation = Animation.named(onboardArray[i])
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            // AnmationViewの設定
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            animationView.play()
            scrollView.addSubview(animationView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
    }

    func setupUI(){
        skipText.setTitle("introAnimationSkip".localized, for: .normal)
        onboardStringArray.append("introAnimationText1".localized)
        onboardStringArray.append("introAnimationText2".localized)
        onboardStringArray.append("introAnimationText3".localized)
    }

}


extension IntroAnimationViewController: UIScrollViewDelegate{
    
    func setUpScroll(){
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height)
        
        for i in 0...2{
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height - 120, width: view.frame.size.width, height: 30))
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
        }
    }
    
    // Set current page to pageController
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
