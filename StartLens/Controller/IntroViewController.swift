//
//  IntroViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Lottie

class IntroViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var onboardArray = ["test", "test", "test"]
    var onboardStringArray = ["私たちはみんな繋がっています。", "2番目のスライドです", "3番目のスライドです。"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // ScrollViewのPagingを可能にする
        scrollView.isPagingEnabled = true
        setUpScroll()
        
        // Lottieの設定
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let isLogIn = UserDefaults.standard.bool(forKey: "isLogIn")
//        // 自動ログイン設定
//        if isLogIn{
//            // 2回目以降の起動
//            print("move home")
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
//            self.present(vc, animated: false, completion: nil)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    
    @IBAction func skipAction(_ sender: Any) {
        print("pushed")
        performSegue(withIdentifier: "LoginSelect", sender: nil)
    }
    
    
    

}


// ScrollViewの実装
extension IntroViewController: UIScrollViewDelegate{
    
    func setUpScroll(){
        
        scrollView.delegate = self
        // ScrollViewのサイズを設定
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: scrollView.frame.size.height)
        
        for i in 0...2{
            // 各Viewの画面領域指定
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            // プロパティの設定
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
        }
    }
    
    // 現在のページ数をPageControlに設定
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
