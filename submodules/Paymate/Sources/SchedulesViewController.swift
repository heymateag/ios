//
//  SchedulesViewController.swift
//  _idx_Paymate_306EA37C_ios_min9.0
//
//  Created by Heymate on 30/10/21.
//

import UIKit
import MobileRTC


class SchedulesViewController: UITableViewController,PaymateNavigationBar,UIPopoverPresentationControllerDelegate {
    
    private lazy var viewModel:ScheduleViewModel = {
        return ScheduleViewModel()
    }()
    private var mOffers:[OfferDetails] = []
    private var mOrders:[MyOrder] = []
    private var mSchedulesHeaderView:ScheduleHeaderView?
    
    private var isOffersView = true
    private var isZoomExit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ScheduleCell", bundle: Bundle.main), forCellReuseIdentifier: "ScheduleCell")
        if let hv = Bundle.main.loadNibNamed("ScheduleHeaderView", owner: self, options: nil)?.first as? ScheduleHeaderView {
            mSchedulesHeaderView = hv
            mSchedulesHeaderView?.onSegmentSelection = {[weak self] isOrders,isOffers in
                if isOrders {
                    self?.onMyOrders()
                } else {
                    self?.onMyOffers()
                }
            }
            onMyOffers()
            self.tableView.tableHeaderView = hv
        }
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        tableView.tableFooterView = emptyView
        loadOffers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarWithType(navType: .NavCenterTitleWithBackButton, centerTitle: "Schedules", leftSelector: #selector(dismissBoard), rightSelector: nil)
        if isZoomExit {
            dismiss(animated: true, completion: nil)
        }
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissBoard))
    }
    
    @objc func dismissBoard() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func onMyOffers() {
        isOffersView = true
        tableView.reloadData()
    }
    
    @objc func onMyOrders() {
        isOffersView = false
        tableView.reloadData()
    }
}

extension SchedulesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOffersView ? mOffers.count : mOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as? ScheduleCell {
            cell.meetingActionBtn.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
            cell.btnMoreOptions.addTarget(self, action: #selector(showPopover(sender:)), for: .touchUpInside)
            if isOffersView {
                cell.configureForOffer(mOffers[indexPath.row])
            } else {
                cell.configureForOrder(mOrders[indexPath.row])
            }
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ScheduleCell {
            showPopover(sender: cell.meetingActionBtn)
        }
    }
    
    @objc func onConfirm() {
        isZoomExit = true
        MobileRTC.shared().setMobileRTCRootController(self.navigationController)
        if isOffersView {
            if let authorizationService = MobileRTC.shared().getAuthService(), authorizationService.isLoggedIn() {
                print("logged in")
                startMeeting()
            } else {
                presentLogInAlert()
            }
        } else {
            presentJoinMeetingAlert()
        }
    }
    
    @objc private func showPopover(sender:UIButton) {
        let optionItemListVC = ScheduleOptionsTableViewController()
        optionItemListVC.modalPresentationStyle = .popover
        guard let popoverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Set Modal presentation style") }
        popoverPresentationController.sourceView = sender
//        optionItemListVC.preferredContentSize = CGSize(width: 200, height: 200)
        popoverPresentationController.delegate = self
        self.present(optionItemListVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension SchedulesViewController {
    
    private func loadOffers() {
        RappleActivityIndicatorView.startAnimating()
        viewModel.getMyOffers {[weak self] (error) in
            RappleActivityIndicatorView.stopAnimation()
            guard let self = self, error == nil else { return }
            self.mOffers = self.viewModel.offers()
            self.mSchedulesHeaderView?.updateOffersCount(count: self.mOffers.count)
            self.tableView.reloadData()
        }
        
        viewModel.getMyOrders {[weak self] (error) in
            RappleActivityIndicatorView.stopAnimation()
            guard let self = self, error == nil else { return }
            self.mOrders = self.viewModel.orders()
            self.mSchedulesHeaderView?.updateOrdersCount(count: self.mOrders.count)
            self.tableView.reloadData()
        }
    }
}

extension SchedulesViewController {
    func joinMeeting(meetingNumber: String, meetingPassword: String) {
        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
        if let meetingService = MobileRTC.shared().getMeetingService() {

            // Set the ViewController to be the MobileRTCMeetingServiceDelegate
            meetingService.delegate = self
            
            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
    }

    /// Logs user into their Zoom account using the user's Zoom email and password.
    ///
    /// Assign a MobileRTCAuthDelegate to listen to authorization events including onMobileRTCLoginReturn(_ returnValue: Int).
    ///
    /// - Parameters:
    ///   - email: The user's email address attached to their Zoom account.
    ///   - password: The user's password attached to their Zoom account.
    /// - Precondition:
    ///   - Zoom SDK must be initialized and authorized.
    func logIn(email: String, password: String) {
        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
        if let authorizationService = MobileRTC.shared().getAuthService() {
            // Call the login function in MobileRTCAuthService. This will attempt to log in the user.
            print("call zoom login")
            
            authorizationService.login(withEmail: email, password: password, rememberMe: true)
        } else {
            startMeeting()
        }
    }

    /// Creates and starts a Zoom instant meeting. An instant meeting is an unscheduled meeting that begins instantly.
    ///
    /// Assign a MobileRTCMeetingServiceDelegate to listen to meeting events and start meeting status.
    ///
    /// - Precondition:
    ///   - Zoom SDK must be initialized and authorized.
    ///   - MobileRTC.shared().setMobileRTCRootController() has been called.
    ///   - User has logged into Zoom successfully.
    func startMeeting() {
        print("starting meeting")
        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
        if let meetingService = MobileRTC.shared().getMeetingService() {
            print("call meeting service")
            // Set the ViewController to be the MobileRTCMeetingServiceDelegate
            meetingService.delegate = self

            // Create a MobileRTCMeetingStartParam to provide the MobileRTCMeetingService with the necessary info to start an instant meeting.
            // In this case we will use MobileRTCMeetingStartParam4LoginlUser(), since the user has logged into Zoom.
            let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()

            // Call the startMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            meetingService.startMeeting(with: startMeetingParameters)
        } else {
            print("no meeting service")
        }
    }

    // MARK: - Convenience Alerts
    /// Creates alert for prompting the user to enter meeting number and password for joining a meeting.
    func presentJoinMeetingAlert() {
        let alertController = UIAlertController(title: "Join meeting", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting number"
            textField.keyboardType = .phonePad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting password"
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let joinMeetingAction = UIAlertAction(title: "Join meeting", style: .default, handler: { alert -> Void in
            let numberTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField

            if let meetingNumber = numberTextField.text, let password = passwordTextField.text {
                self.joinMeeting(meetingNumber: meetingNumber, meetingPassword: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(joinMeetingAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    /// Creates alert for prompting the user to enter their Zoom credentials for starting a meeting.
    func presentLogInAlert() {
        let alertController = UIAlertController(title: "Log in", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let logInAction = UIAlertAction(title: "Log in", style: .default, handler: { alert -> Void in
            let emailTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField

            if let email = emailTextField.text, let password = passwordTextField.text {
                self.logIn(email: email, password: password)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

        alertController.addAction(logInAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension SchedulesViewController: MobileRTCMeetingServiceDelegate {
    
    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
    func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case .success:
            print("Successful meeting operation.")
        case .passwordError:
            print("Could not join or start meeting because the meeting password was incorrect.")
        default:
            print("MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }

    // Is called when the user joins a meeting.
    func onJoinMeetingConfirmed() {
        print("Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Current meeting state: \(state.rawValue)")
    }
}

extension SchedulesViewController {
    private func getMyOffers() {
        PeyServiceController.shared.getOffers(request: EmptyRequest()) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let offers):
                self.mOffers = offers.data
                if !offers.data.isEmpty {
                    self.mSchedulesHeaderView?.updateOffersCount(count: offers.data.count)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("getOffers error \(error)")
            }
        }
    }
    
    private func getMyOrders() {
        PeyServiceController.shared.getMyOrders(request: EmptyRequest()) {[weak self] (result, _) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mOrders = response.data
                if !response.data.isEmpty {
                    self.mSchedulesHeaderView?.updateOrdersCount(count: response.data.count)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("error on my orders \(error)")
            }
        }
    }
}
