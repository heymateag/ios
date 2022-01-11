import Foundation
import UIKit
import Display
import AsyncDisplayKit
import Postbox
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import TelegramUIPreferences
import DeviceAccess
import AccountContext
import AlertUI
import PresentationDataUtils
import TelegramPermissions
import TelegramNotices
import ContactsPeerItem
import SearchUI
import TelegramPermissionsUI
import AppBundle
import ContactListUI
import MobileRTC
import PaymateChain
//import PromiseKit
//import PromiseKit
//import RootPaymate
//import WalletConnect

class PaymateRootNode: ASDisplayNode,UITableViewDelegate,UITableViewDataSource {
    let contactListNode: ContactListNode
    var controller:PaymateRootViewController!
    private let context: AccountContext
    private(set) var searchDisplayController: SearchDisplayController?
    private var offersTableViewNode:ASDisplayNode?
    private var containerLayout: (ContainerViewLayout, CGFloat)?
//    var interactor:WCInteractor?
    var navigationBar: NavigationBar?
    var listNode:ListView!
    var requestDeactivateSearch: (() -> Void)?
    var requestOpenPeerFromSearch: ((ContactListPeer) -> Void)?
    var requestAddContact: ((String) -> Void)?
    var openPeopleNearby: (() -> Void)?
    var openInvite: (() -> Void)?

    private var presentationData: PresentationData
    private var presentationDataDisposable: Disposable?
    private var mServicesTableView:ASDisplayNode?


//    weak var controller: ContactsController?

    init(context: AccountContext, sortOrder: Signal<ContactsSortOrder, NoError>, present: @escaping (ViewController, Any?) -> Void, controller: PaymateRootViewController) {
        self.context = context
        self.controller = controller
        BlockchainTest().decode()
        self.presentationData = context.sharedContext.currentPresentationData.with { $0 }

        var addNearbyImpl: (() -> Void)?
        var inviteImpl: (() -> Void)?
        let options = [ContactListAdditionalOption(title: presentationData.strings.Contacts_AddPeopleNearby, icon: .generic(UIImage(bundleImageName: "Contact List/PeopleNearbyIcon")!), action: {
            addNearbyImpl?()
        }), ContactListAdditionalOption(title: presentationData.strings.Contacts_InviteFriends, icon: .generic(UIImage(bundleImageName: "Contact List/AddMemberIcon")!), action: {
            inviteImpl?()
        })]

        let presentation = sortOrder
        |> map { sortOrder -> ContactListPresentation in
            switch sortOrder {
                case .presence:
                    return .orderedByPresence(options: options)
                case .natural:
                    return .natural(options: options, includeChatList: false)
            }
        }

        var contextAction: ((Peer, ASDisplayNode, ContextGesture?) -> Void)?

//        self.contactListNode = ContactListNode(context: context, presentation: presentation, displaySortOptions: true, contextAction: { peer, node, gesture in
//            contextAction?(peer, node, gesture)
//        })
        
        self.contactListNode = ContactListNode.init(context: context, presentation: presentation)
        
//        listNode = ListView()
//        listNode.dynamicBounceEnabled = !self.presentationData.disableAnimations
//        listNode.backgroundColor = UIColor.red
//        listNode.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        super.init()

        self.setViewBlock({
            return UITracingLayerView()
        })

        self.backgroundColor = UIColor.white

    }

   
    deinit {
        self.presentationDataDisposable?.dispose()
    }

    private func updateThemeAndStrings() {
        self.backgroundColor = self.presentationData.theme.chatList.backgroundColor
        self.searchDisplayController?.updatePresentationData(self.presentationData)
    }

    func scrollToTop() {
        if let contentNode = self.searchDisplayController?.contentNode as? ContactsSearchContainerNode {
            contentNode.scrollToTop()
        } else {
            self.contactListNode.scrollToTop()
        }
    }

    func containerLayoutUpdated(_ layout: ContainerViewLayout, navigationBarHeight: CGFloat, actualNavigationBarHeight: CGFloat, transition: ContainedViewLayoutTransition) {
        print("containerLayoutUpdated \(layout)")
        self.containerLayout = (layout, navigationBarHeight)

        var insets = layout.insets(options: [.input])
        insets.top += navigationBarHeight

        var headerInsets = layout.insets(options: [.input])
        headerInsets.top += actualNavigationBarHeight

        if let searchDisplayController = self.searchDisplayController {
            searchDisplayController.containerLayoutUpdated(layout, navigationBarHeight: navigationBarHeight, transition: transition)
        }

        self.contactListNode.containerLayoutUpdated(ContainerViewLayout(size: layout.size, metrics: layout.metrics, deviceMetrics: layout.deviceMetrics, intrinsicInsets: insets, safeInsets: layout.safeInsets, additionalInsets: layout.additionalInsets, statusBarHeight: layout.statusBarHeight, inputHeight: layout.inputHeight, inputHeightIsInteractivellyChanging: layout.inputHeightIsInteractivellyChanging, inVoiceOver: layout.inVoiceOver), headerInsets: headerInsets, transition: transition)

        if(mServicesTableView?.supernode == nil) { // load only once
            mServicesTableView = ASDisplayNode { () -> UIView in
                let services = self.getCollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: layout.size.width, height: layout.size.height)))
//                let btn = loadedView?.viewWithTag(100)
//                print("btn \(btn)")
//                loadedView?.frame = CGRect(x: 0, y: 0, width: layout.size.width, height: 200)
//                loadedView?.backgroundColor = .green
//                services.tableFooterView = loadedView
                return services
            }

//            MobileRTC.shared().setMobileRTCRootController(controller.navigationController)
//            if let meetingService = MobileRTC.shared().getMeetingService() {
//                print("call meeting service")
//                // Set the ViewController to be the MobileRTCMeetingServiceDelegate
////                meetingService.delegate = self
//
//                // Create a MobileRTCMeetingStartParam to provide the MobileRTCMeetingService with the necessary info to start an instant meeting.
//                // In this case we will use MobileRTCMeetingStartParam4LoginlUser(), since the user has logged into Zoom.
//                let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()
//
//                // Call the startMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
//                meetingService.startMeeting(with: startMeetingParameters)
//            }

            self.addSubnode(mServicesTableView!)
        }


//        self.addButton(layout: layout)
//        if(mServicesTableView?.supernode == nil) { // load only once
//            mServicesTableView = ASDisplayNode { () -> UIView in
//
//                mServicesTableView = ASDisplayNode { () -> UIView in
//                    let services = self.getCollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: layout.size.width, height: layout.size.height)))
//                    return services
//                }
//                self.addSubnode(mServicesTableView!)
//
//
//
////                let safeAreaTop: CGFloat
////                if #available(iOS 11.0, *) {
////                    safeAreaTop = self.controller.view.safeAreaInsets.top
////                } else {
////                    safeAreaTop = self.controller.topLayoutGuide.length
////                }
////                print("safeAreaTop \(safeAreaTop)")
////                let frame = CGRect(x: 0, y: safeAreaTop+headerInsets.top, width: layout.size.width, height: layout.size.height-safeAreaTop-headerInsets.top-44)
////                let services = OffersListTableview(frame: frame)
////                services.context = self.context
////                services.cvc = self.controller
////                let services = self.getCollectionView(frame: CGRect(x: 0, y: 100, width: layout.size.width, height: layout.size.height))
////                return services
//            }
//            self.addSubnode(mServicesTableView!)
//        }
    }

    private func getCollectionView(frame:CGRect) -> UITableView {
        let tv = UITableView(frame: frame)
        tv.delegate = self
        tv.dataSource = self
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        tv.tableFooterView = emptyView
//        let view = OffersListTableview(frame: frame)
        return tv
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "servicesCell")
        cell?.selectionStyle = .none
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "servicesCell")
        }
        
        if indexPath.row == 0 {
            cell?.imageView?.image = UIImage(named: "terms")
            cell?.textLabel?.text = "My Offers"
        } else {
            cell?.imageView?.image = UIImage(named: "expiration")
            cell?.textLabel?.text = "My Schedules"
        }
        return cell!
    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect row \(indexPath.row)")
//        let v = Bundle.main.loadNibNamed("DetailsHeaderCell", owner: self, options: nil)
//        print("DetailsHeaderCell xib \(v)")
        
        if indexPath.row == 1 {
//            let v1 = OffersListTableViewController.init(context: context)
//            controller.switchToChatsController?()

//            v1.switchToChatsController = controller.switchToChatsController!
//            controller.present(v1, in: .current)
//            controller.navigationController?.pushViewController(v1, animated: true)

            let schedules = SchedulesViewController()
            let navigation = UINavigationController(rootViewController: schedules)
            navigation.modalPresentationStyle = .fullScreen
            controller.present(navigation, animated: true)
            
        } else if indexPath.row == 0 {
//            let v = SchedulesViewController()


//            let c = SchedulesHomeViewController.init(context: context)
            let offers = UserOffersTableViewController()
            let navigation = UINavigationController(rootViewController: offers)
            offers.rootPayController = self.controller
            navigation.modalPresentationStyle = .fullScreen
            controller.present(navigation, animated: true)
//            (controller.navigationController as? NavigationController)?.pushViewController(offers, animated: true)
//            controller.navigationController?.pushViewController(c, animated: true)
        }
    }
}

//

private func fixListNodeScrolling(_ listNode: ListView, searchNode: NavigationBarSearchContentNode) -> Bool {
    if searchNode.expansionProgress > 0.0 && searchNode.expansionProgress < 1.0 {
        let scrollToItem: ListViewScrollToItem
        let targetProgress: CGFloat
        if searchNode.expansionProgress < 0.6 {
            scrollToItem = ListViewScrollToItem(index: 1, position: .top(-navigationBarSearchContentHeight), animated: true, curve: .Default(duration: nil), directionHint: .Up)
            targetProgress = 0.0
        } else {
            scrollToItem = ListViewScrollToItem(index: 1, position: .top(0.0), animated: true, curve: .Default(duration: nil), directionHint: .Up)
            targetProgress = 1.0
        }
        searchNode.updateExpansionProgress(targetProgress, animated: true)

        listNode.transaction(deleteIndices: [], insertIndicesAndItems: [], updateIndicesAndItems: [], options: ListViewDeleteAndInsertOptions(), scrollToItem: scrollToItem, updateSizeAndInsets: nil, stationaryItemRange: nil, updateOpaqueState: nil, completion: { _ in })
        return true
    } else if searchNode.expansionProgress == 1.0 {
        var sortItemNode: ListViewItemNode?
        var nextItemNode: ListViewItemNode?

//        listNode.forEachItemNode({ itemNode in
//            if sortItemNode == nil, let itemNode = itemNode as? ContactListActionItemNode {
//                sortItemNode = itemNode
//            } else if sortItemNode != nil && nextItemNode == nil {
//                nextItemNode = itemNode as? ListViewItemNode
//            }
//        })

        if let sortItemNode = sortItemNode {
            let itemFrame = sortItemNode.apparentFrame
            if itemFrame.contains(CGPoint(x: 0.0, y: listNode.insets.top)) {
                var scrollToItem: ListViewScrollToItem?
                if itemFrame.minY + itemFrame.height * 0.6 < listNode.insets.top {
                    scrollToItem = ListViewScrollToItem(index: 0, position: .top(-50), animated: true, curve: .Default(duration: nil), directionHint: .Up)
                } else {
                    scrollToItem = ListViewScrollToItem(index: 0, position: .top(0), animated: true, curve: .Default(duration: nil), directionHint: .Up)
                }
                listNode.transaction(deleteIndices: [], insertIndicesAndItems: [], updateIndicesAndItems: [], options: ListViewDeleteAndInsertOptions(), scrollToItem: scrollToItem, updateSizeAndInsets: nil, stationaryItemRange: nil, updateOpaqueState: nil, completion: { _ in })
                return true
            }
        }
    }
    return false
}


open class PaymateRootViewController: ViewController {
    let context: AccountContext

    private var contactsNode: PaymateRootNode {
        return self.displayNode as! PaymateRootNode
    }
    private var validLayout: ContainerViewLayout?

    private let index: PeerNameIndex = .lastNameFirst

    private var _ready = Promise<Bool>()
    override public var ready: Promise<Bool> {
        return self._ready
    }

    private var presentationData: PresentationData
    private var presentationDataDisposable: Disposable?
    private var authorizationDisposable: Disposable?
    private let sortOrderPromise = Promise<ContactsSortOrder>()

    private var searchContentNode: NavigationBarSearchContentNode?

    public var switchToChatsController: (() -> Void)?

    public override func updateNavigationCustomData(_ data: Any?, progress: CGFloat, transition: ContainedViewLayoutTransition) {
        if self.isNodeLoaded {
            self.contactsNode.contactListNode.updateSelectedChatLocation(data as? ChatLocation, progress: progress, transition: transition)

        }
    }

    public init(context: AccountContext) {
        self.context = context
        self.presentationData = context.sharedContext.currentPresentationData.with { $0 }

        super.init(navigationBarPresentationData: NavigationBarPresentationData(presentationData: self.presentationData))

        self.statusBar.statusBarStyle = self.presentationData.theme.rootController.statusBarStyle.style
//        AppUtils.saveLoginToken()
        self.title = "Services"
        self.tabBarItem.title = "Services"

        let icon: UIImage?
        if useSpecialTabBarIcons() {
            icon = UIImage(bundleImageName: "Chat List/Tabs/Holiday/IconContacts")
        } else {
            icon = UIImage(bundleImageName: "Chat List/Tabs/IconContacts")
        }

        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon

//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.presentationData.strings.Common_Back, style: .plain, target: nil, action: nil)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: PresentationResourcesRootController.navigationAddIcon(self.presentationData.theme), style: .plain, target: self, action: #selector(self.addPressed))

        self.scrollToTop = { [weak self] in
            if let strongSelf = self {
                if let searchContentNode = strongSelf.searchContentNode {
                    searchContentNode.updateExpansionProgress(1.0, animated: true)
                }
                strongSelf.contactsNode.scrollToTop()
            }
        }

        self.presentationDataDisposable = (context.sharedContext.presentationData
        |> deliverOnMainQueue).start(next: { [weak self] presentationData in
            if let strongSelf = self {
                let previousTheme = strongSelf.presentationData.theme
                let previousStrings = strongSelf.presentationData.strings

                strongSelf.presentationData = presentationData

                if previousTheme !== presentationData.theme || previousStrings !== presentationData.strings {
                    strongSelf.updateThemeAndStrings()
                }
            }
        })

        if #available(iOSApplicationExtension 10.0, iOS 10.0, *) {
            self.authorizationDisposable = (combineLatest(DeviceAccess.authorizationStatus(subject: .contacts), combineLatest(context.sharedContext.accountManager.noticeEntry(key: ApplicationSpecificNotice.permissionWarningKey(permission: .contacts)!), context.account.postbox.preferencesView(keys: [PreferencesKeys.contactsSettings]), context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.contactSynchronizationSettings]))
            |> map { noticeView, preferences, sharedData -> (Bool, ContactsSortOrder) in
                let settings: ContactsSettings = preferences.values[PreferencesKeys.contactsSettings] as? ContactsSettings ?? ContactsSettings.defaultSettings
                let synchronizeDeviceContacts: Bool = settings.synchronizeContacts

                let contactsSettings = sharedData.entries[ApplicationSpecificSharedDataKeys.contactSynchronizationSettings] as? ContactSynchronizationSettings

                let sortOrder: ContactsSortOrder = contactsSettings?.sortOrder ?? .presence
                if !synchronizeDeviceContacts {
                    return (true, sortOrder)
                }
                let timestamp = noticeView.value.flatMap({ ApplicationSpecificNotice.getTimestampValue($0) })
                if let timestamp = timestamp, timestamp > 0 {
                    return (true, sortOrder)
                } else {
                    return (false, sortOrder)
                }
            })
            |> deliverOnMainQueue).start(next: { [weak self] status, suppressedAndSortOrder in
                if let strongSelf = self {
                    let (suppressed, sortOrder) = suppressedAndSortOrder
                    strongSelf.tabBarItem.badgeValue = status != .allowed && !suppressed ? "!" : nil
                    strongSelf.sortOrderPromise.set(.single(sortOrder))
                }
            })
        } else {
            self.sortOrderPromise.set(context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.contactSynchronizationSettings])
            |> map { sharedData -> ContactsSortOrder in
                let settings = sharedData.entries[ApplicationSpecificSharedDataKeys.contactSynchronizationSettings] as? ContactSynchronizationSettings
                return settings?.sortOrder ?? .presence
            })
        }

        self.searchContentNode = NavigationBarSearchContentNode(theme: self.presentationData.theme, placeholder: self.presentationData.strings.Common_Search, activate: { [weak self] in
            self?.activateSearch()
        })
//        self.navigationBar?.setContentNode(self.searchContentNode, animated: false)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.presentationDataDisposable?.dispose()
        self.authorizationDisposable?.dispose()
    }

    private func updateThemeAndStrings() {
        self.statusBar.statusBarStyle = self.presentationData.theme.rootController.statusBarStyle.style
        self.navigationBar?.updatePresentationData(NavigationBarPresentationData(presentationData: self.presentationData))
        self.searchContentNode?.updateThemeAndPlaceholder(theme: self.presentationData.theme, placeholder: self.presentationData.strings.Common_Search)
        self.title = self.presentationData.strings.Contacts_Title
        self.tabBarItem.title = self.presentationData.strings.Contacts_Title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.presentationData.strings.Common_Back, style: .plain, target: nil, action: nil)
        if self.navigationItem.rightBarButtonItem != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: PresentationResourcesRootController.navigationAddIcon(self.presentationData.theme), style: .plain, target: self, action: #selector(self.addPressed))
        }
    }

    override public func loadDisplayNode() {
        self.displayNode = PaymateRootNode(context: self.context, sortOrder: sortOrderPromise.get() |> distinctUntilChanged, present: { [weak self] c, a in
            self?.present(c, in: .window(.root), with: a)
        }, controller: self)
        self._ready.set(self.contactsNode.contactListNode.ready)

        self.contactsNode.navigationBar = self.navigationBar

        self.contactsNode.contactListNode.contentOffsetChanged = { [weak self] offset in
            if let strongSelf = self, let searchContentNode = strongSelf.searchContentNode {
                var progress: CGFloat = 0.0
                switch offset {
                    case let .known(offset):
                        progress = max(0.0, (searchContentNode.nominalHeight - max(0.0, offset - 50.0))) / searchContentNode.nominalHeight
                    case .none:
                        progress = 1.0
                    default:
                        break
                }
                searchContentNode.updateExpansionProgress(progress)
            }
        }

        self.contactsNode.contactListNode.contentScrollingEnded = { [weak self] listView in
            if let strongSelf = self, let searchContentNode = strongSelf.searchContentNode {
                return fixListNodeScrolling(listView, searchNode: searchContentNode)
            } else {
                return false
            }
        }
//        self.contactsNode.frame = CGRect(x: 0, y: 0, width: 500, height: 600)
        self.displayNodeDidLoad()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        checkForLogin()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackButton()
        if AppUtils.getLoginToken().isEmpty {
            PeyServiceController.shared.loginUser(request: LoginRequest()) { (response, _) in
                switch response {
                    case .success(let login):
                        AppUtils.saveLoginToken(token: login.idToken?.jwtToken ?? "")
                    case .failure(let error):
                        print("login error \(error)")
                }
            }
        }
//        AppUtils.saveLoginToken(token: "")
        self.tabBarController?.tabBar.isHidden = false
        self.contactsNode.contactListNode.enableUpdates = true
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.contactsNode.contactListNode.enableUpdates = false
    }

    override public func containerLayoutUpdated(_ layout: ContainerViewLayout, transition: ContainedViewLayoutTransition) {
        super.containerLayoutUpdated(layout, transition: transition)

        self.validLayout = layout
        hideBackButton()
        self.contactsNode.containerLayoutUpdated(layout, navigationBarHeight: 0, actualNavigationBarHeight: 44, transition: transition)
    }

    private func checkForLogin() {
        if (AppUtils.getLoginPhoneNumber() ?? "").isEmpty {
            print("missing phone number")
            
        } else {
            if AppUtils.getLoginToken().isEmpty {
                PeyServiceController.shared.loginUser(request: LoginRequest.init()) { (response, _) in
                    switch response {
                        case .success(let login):
                            AppUtils.saveLoginToken(token: login.idToken?.jwtToken ?? "")
                        case .failure(let error):
                            print("login error \(error)")
                    }
                }
            }
        }
    }

    private func hideBackButton() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationBar?.tintColor = UIColor(red: 0.318, green: 0.49, blue: 0.635, alpha: 1)
        self.navigationBar?.backgroundColor = UIColor(red: 0.318, green: 0.49, blue: 0.635, alpha: 1)
//        setOriginalBackImage(selector: #selector(onBack))
    }

    private func setOriginalBackImage(selector:Selector) {
        let backButton = UIBarButtonItem(image: UIImage(named: "back_btn")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
        self.navigationItem.leftBarButtonItem = backButton
    }


    @objc func addPressed() {
    }
    private func activateSearch() {
    }

}
