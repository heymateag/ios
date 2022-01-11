//
//  OfferDetailsTableViewController.swift
//  GraphApp
//
//  Created by Heymate on 01/11/21.
//

import UIKit

class OfferDetailsTableViewController: UITableViewController,PaymateNavigationBar,PaymateAlerts {

    private var mFooterView:UIView?
    var mSelectedOffer:OfferDetails?
    private var currentSelectedSchedule:OfferDetailsSchedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "DetailsHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "OfferDetailsHeaderCell")
        tableView.register(UINib(nibName: "PaymentTermsCell", bundle: Bundle.main), forCellReuseIdentifier: "OfferDetailsTermsCell")
        tableView.register(UINib(nibName: "TnCCell", bundle: Bundle.main), forCellReuseIdentifier: "OfferDetailsTnCCell")
       
        tableView.estimatedRowHeight = UITableView.automaticDimension
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        if let view = Bundle.main.loadNibNamed("DetailsHeaderView", owner: self, options: nil)?.first as? UIView {
            tableView.tableHeaderView = view
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarWithType(navType: .NavCenterTitleWithBackButton, centerTitle: "Offer Details", leftSelector: #selector(onBackBtn), rightSelector: nil)
        let v = Bundle.main.loadNibNamed("DetailsFooterView", owner: self, options: nil)?.first as? UIView
        if let footerView = v {
            footerView.frame = CGRect(x: 0, y: (navigationController?.view ?? view).frame.size.height-80, width: view.frame.size.width, height: 80)
            mFooterView = footerView
            
            let btnPromote = mFooterView?.viewWithTag(100) as? UIButton
            let btnBookNow = mFooterView?.viewWithTag(101) as? UIButton
            
            btnPromote?.roundedPaymateView(cornerRadius: 8)
            btnBookNow?.roundedPaymateView(cornerRadius: 8)
            
            btnPromote?.addTarget(self, action: #selector(onPromoteOffer), for: .touchUpInside)
            btnBookNow?.addTarget(self, action: #selector(onBookOffer), for: .touchUpInside)
            
            mFooterView?.viewWithTag(101)?.roundedPaymateView(cornerRadius: 8)
            
            navigationController?.view.addSubview(footerView)
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mFooterView?.removeFromSuperview()
    }

    @objc func onBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = mSelectedOffer else {
            return 0
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (mSelectedOffer?.payment_terms.cancellation.count ?? 0)+1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0,let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsHeaderCell") as? OfferDetailsHeaderCell {
//            let components = PrepareOfferListView.prepareOfferDetailsViewFromCell(cell: cell, offerDetails: nil)
//            components.single?.addTarget(self, action: #selector(onOfferOption), for: .touchUpInside)
//            components.bundle?.addTarget(self, action: #selector(onOfferOption), for: .touchUpInside)
//            components.subscription?.addTarget(self, action: #selector(onOfferOption), for: .touchUpInside)
            cell.configureOffer(mSelectedOffer!)
            cell.onOfferTypeSelection = {[weak self] (type,button) in
                
            }
            return cell
        } else if indexPath.section == 1,let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsTermsCell") as? OfferDetailsTermsCell {
            cell.configureTerms(offer: mSelectedOffer!, row: indexPath.row)
//            PrepareOfferListView.prepareOfferDetailsPaymentsView(cell: cell, offerDetails: mSelectedOffer, row: indexPath.row)
            return cell
        } else if indexPath.section == 2,let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsTnCCell") as? OfferDetailsTnCCell {
            cell.offerTerms.text = mSelectedOffer?.description
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return getOfferDetailsSectionHeaderView(titleText: "Payment terms")
        } else if section == 2 {
            return getOfferDetailsSectionHeaderView(titleText: "Terms and conditions")
        }
        return nil
    }
    
    private func getOfferDetailsSectionHeaderView(titleText:String) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        v.backgroundColor = .white
        let title = UILabel(frame: CGRect(x: 16, y: 16, width: v.frame.size.width, height: 20))
        title.center.y = v.center.y
        title.text = titleText
        title.textColor = UIColor(red: 41/255, green: 169/255, blue: 235/255, alpha: 1)
        v.addSubview(title)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0}
        return 44
    }

}

extension OfferDetailsTableViewController {
    
    @objc func onPromoteOffer() {
        
    }
    
    @objc func onBookOffer() {
        guard let so = mSelectedOffer else { return }
        let showSchedules = ChooseScheduleViewController(nibName: "ChooseSchedule", bundle: Bundle.main)
        showSchedules.modalPresentationStyle = .overCurrentContext
        showSchedules.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        showSchedules.mSchedules = so.schedules
        showSchedules.currentSelectedScheduleId = currentSelectedSchedule?.id
        showSchedules.onConfirmSchedule = {[weak self] schedule in
            if let millis = Double(schedule.form_time) {
                self?.showToastMessage(text: AppUtils.getScheduledDateDisplay(milliSeconds: millis))
            }
            self?.currentSelectedSchedule = schedule
        }
        showSchedules.onConfirmSchedule = {[weak self] schedule in
            self?.currentSelectedSchedule = schedule
            print("selected schedule \(schedule)")
        }
        self.present(showSchedules, animated: true, completion: nil)
    }
    
    @objc func onOfferOption(sender:UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell {
            PrepareOfferListView.didSelectOfferMode(sender: sender, cell: cell)
        }
    }
}
