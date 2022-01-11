//
//  UserOffersTableViewController.swift
//  _idx_Paymate_0EEE5C76_ios_min9.0
//
//  Created by Heymate on 29/10/21.
//

import UIKit
import TelegramCore
import MobileRTC
import AppBundle
import Display
import PromiseKit

class UserOffersTableViewController: UITableViewController,PaymateNavigationBar,PaymateAlerts {
    
    private var mOffers:[OfferDetails] = []
    private var newOfferFooter:UIView?
    private var mSelectedSchedule:OfferDetailsSchedule?
    var rootPayController:PaymateRootViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        self.tableView.register(UINib(nibName: "OfferListCell", bundle: Bundle.main), forCellReuseIdentifier: "UserOffersListCell")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNewOfferView()
        self.setNavigationBarWithType(navType: .NavCenterTitleWithBackButton, centerTitle: "Offers", leftSelector: #selector(dismissOfferView), rightSelector: nil)
        getAllOffers()
    }
    
    @objc func dismissOfferView() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newOfferFooter?.removeFromSuperview()
    }
    
    private func addNewOfferView() {
        let v = Bundle.main.loadNibNamed("NewOfferButton", owner: self, options: nil)?.first as? UIView
        if let newOfferView = v {
            (newOfferView.viewWithTag(NewOfferButton.NewOffer.rawValue) as? UIButton)?.addTarget(self, action: #selector(onNewOffer), for: .touchUpInside)
            newOfferView.frame = CGRect(x: 0, y: (navigationController?.view ?? view).frame.size.height-80, width: view.frame.size.width, height: 80)
            newOfferFooter = newOfferView
            navigationController?.view.addSubview(newOfferView)
        }
    }
}

extension UserOffersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mOffers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserOffersListCell") as? UserOffersListCell {
            cell.configureOffer(mOffers[indexPath.row])
            cell.onOfferTypeSelection = {[weak self](type,button) in
                if let cell = button.superview?.superview?.superview?.superview?.superview?.superview?.superview as? UserOffersListCell,
                   let path = tableView.indexPath(for: cell) {
                    self?.didChangeOfferType(path: path)
                }
            }
            cell.btnShareOffer.addTarget(self, action: #selector(onShareOffer(sender:)), for: .touchUpInside)
            cell.btnBookNow
                .addTarget(self, action: #selector(onBookNow(sender:)), for: .touchUpInside)
            cell.btnSeeDetails.addTarget(self, action: #selector(onSeeMore(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    private func didChangeOfferType(path:IndexPath) {
        print("didChangeOfferType \(path)")
    }
}

extension UserOffersTableViewController {
    
    @objc func onBookNow(sender:UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell,let path = tableView.indexPath(for: cell) {
            let showSchedules = ChooseScheduleViewController(nibName: "ChooseSchedule", bundle: Bundle.main)
            showSchedules.modalPresentationStyle = .overCurrentContext
            showSchedules.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            showSchedules.mSchedules = mOffers[path.row].schedules
            showSchedules.currentSelectedScheduleId = mSelectedSchedule?.id ?? ""
            showSchedules.onConfirmSchedule = {[weak self] schedule in
                print("show alert toast")
                if let millis = Double(schedule.form_time) {
                    self?.showToastMessage(text: AppUtils.getScheduledDateDisplay(milliSeconds: millis))
                }
                self?.mSelectedSchedule = schedule
            }
            self.present(showSchedules, animated: true, completion: nil)
        }
    }
    
    @objc func onSeeMore(sender:UIButton) {
        print("onSeeMore")
        if let cell = sender.superview?.superview?.superview?.superview as? UserOffersListCell,let path = tableView.indexPath(for: cell) {
            let details = OfferDetailsTableViewController()
            details.mSelectedOffer = mOffers[path.row]
            self.navigationController?.pushViewController(details, animated: true)
        }
    }
    
    @objc func onShareOffer(sender:UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? UserOffersListCell,let path = tableView.indexPath(for: cell) {
            let id = mOffers[path.row].id
            let url = URL(string: Constants.BASE_URL+Constants.API_GET_SINGLE_OFFER+"/"+id)
            showShareView(items: [url!])
        }
    }
    
    private func showShareView(items: [Any],
                       excludedActivityTypes: [UIActivity.ActivityType]? = nil,
                       ipad: (forIpad: Bool, view: UIView?) = (false, nil)) {
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        if ipad.forIpad {
            activityViewController.popoverPresentationController?.sourceView = ipad.view
        }
        
        if let excludedActivityTypes = excludedActivityTypes {
            activityViewController.excludedActivityTypes = excludedActivityTypes
        }
        
        self.present(activityViewController, animated: true, completion: nil)
//        return activityViewController
    }

    
    @objc func onPromoteOffer(sender:UIButton) {
        
    }
    
    private func getAllOffers() {
        RappleActivityIndicatorView.startAnimating()
        PeyServiceController.shared.getOffers(request: EmptyRequest()) {[weak self] (result, _) in
            RappleActivityIndicatorView.stopAnimation()
            guard let self = self else { return }
            switch result {
            case .success(let offers):
                self.mOffers = offers.data
                print("offers \(offers.data.count)")
                if offers.data.isEmpty {
                    self.showAlertWithMessage(title: "Offers", message: "No offers found.")
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("getOffers error \(error)")
            }
        }
    }
    
    @objc func onNewOffer() {
        let createOffer = CreateOfferTableViewController()
        self.navigationController?.pushViewController(createOffer, animated: true)
    }
}
