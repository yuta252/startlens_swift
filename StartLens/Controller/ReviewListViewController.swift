//
//  ReviewListViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ReviewListViewController: UIViewController {

    @IBOutlet weak var reviewTitleText: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var noReview: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var token = String()
    var spot: Spot?
    var spotId: Int?
    var language = String()
    var reviews = [Review]()
    var format = ISO8601DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial settings
        language = Language.getLanguage()
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else {
            // if cannot get a token, move to login screen
            print("Action: ViewDidLoad, Message: No token Error")
            return
        }
        token = savedToken
        self.reviews = self.spot!.reviews
        self.spotId = self.spot?.id
        
        // UI settings
        setupUI()
        setupTable()
        reviewTableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        if self.reviews.count != 0 {
            self.noReview.isHidden = true
            self.noReview.isHidden = true
        } else {
            // No review
            self.noReview.isHidden = false
            self.noReview.isHidden = false
        }
        
        // Date format
        format.formatOptions = .withFullDate

        reviewTitleText.text = "revewListTitle".localized
        noReview.text = "noReviewText".localized
    }
    
    func setupTable() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.register(UINib(nibName: "WriterCell", bundle: nil), forCellReuseIdentifier: "WriterCell")
        reviewTableView.estimatedRowHeight = 110
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.separatorStyle = .none
        reviewTableView.bounces = false
        reviewTableView.isScrollEnabled = false
    }
}

extension ReviewListViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ReviewListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterCell", for: indexPath) as! WriterCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.writerName.text = reviews[indexPath.row].tourist.username
        // Format date to string
        let date = format.date(from: self.reviews[indexPath.row].createdAt)
        cell.postedDate.text = format.string(from: date!)
        // Cosmos
        cell.ratingStar.settings.updateOnTouch = false
        cell.ratingStar.rating = Double(reviews[indexPath.row].rating)
        cell.ratingStar.settings.fillMode = .half
        cell.ratingNumber.text = String(reviews[indexPath.row].rating)
        cell.reviewPosted.text = reviews[indexPath.row].postReview
        return cell
    }
}
