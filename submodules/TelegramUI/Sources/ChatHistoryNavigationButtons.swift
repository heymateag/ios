import Foundation
import UIKit
import Display
import AsyncDisplayKit
import TelegramPresentationData

final class ChatHistoryNavigationButtons: ASDisplayNode {
    private var theme: PresentationTheme
    private var dateTimeFormat: PresentationDateTimeFormat
    
    private let mentionsButton: ChatHistoryNavigationButtonNode
    private let mentionsButtonTapNode: ASDisplayNode
    private let downButton: ChatHistoryNavigationButtonNode
    
    var downPressed: (() -> Void)? {
        didSet {
            self.downButton.tapped = self.downPressed
        }
    }
    
    var mentionsPressed: (() -> Void)?
    var mentionsMenu: (() -> Void)?
    
    var displayDownButton: Bool = false {
        didSet {
            if oldValue != self.displayDownButton {
                let _ = self.updateLayout(transition: .animated(duration: 0.3, curve: .spring))
            }
        }
    }
    
    var unreadCount: Int32 = 0 {
        didSet {
            if self.unreadCount != 0 {
                self.downButton.badge = compactNumericCountString(Int(self.unreadCount), decimalSeparator: self.dateTimeFormat.decimalSeparator)
            } else {
                self.downButton.badge = ""
            }
        }
    }
    
    var mentionCount: Int32 = 0 {
        didSet {
            if self.mentionCount != 0 {
                self.mentionsButton.badge = compactNumericCountString(Int(self.mentionCount), decimalSeparator: self.dateTimeFormat.decimalSeparator)
            } else {
                self.mentionsButton.badge = ""
            }
            
            if (oldValue != 0) != (self.mentionCount != 0) {
                let _ = self.updateLayout(transition: .animated(duration: 0.3, curve: .spring))
            }
        }
    }
    
    init(theme: PresentationTheme, dateTimeFormat: PresentationDateTimeFormat) {
        self.theme = theme
        self.dateTimeFormat = dateTimeFormat
        
        self.mentionsButton = ChatHistoryNavigationButtonNode(theme: theme, type: .mentions)
        self.mentionsButton.alpha = 0.0
        self.mentionsButton.isHidden = true
        self.mentionsButtonTapNode = ASDisplayNode()
        
        self.downButton = ChatHistoryNavigationButtonNode(theme: theme, type: .down)
        self.downButton.alpha = 0.0
        self.downButton.isHidden = true
        
        super.init()
        
        self.mentionsButton.isUserInteractionEnabled = false
        
        self.addSubnode(self.mentionsButton)
        self.addSubnode(self.mentionsButtonTapNode)
        self.addSubnode(self.downButton)
    }
    
    override func didLoad() {
        super.didLoad()
        
        let tapRecognizer = TapLongTapOrDoubleTapGestureRecognizer(target: self, action: #selector(self.mentionsTap(_:)))
        tapRecognizer.tapActionAtPoint = { _ in
            return .waitForSingleTap
        }
        self.mentionsButtonTapNode.view.addGestureRecognizer(tapRecognizer)
    }
    
    func update(theme: PresentationTheme, dateTimeFormat: PresentationDateTimeFormat) {
        if self.theme !== theme || self.dateTimeFormat != dateTimeFormat {
            self.theme = theme
            self.dateTimeFormat = dateTimeFormat
            
            self.mentionsButton.updateTheme(theme: theme)
            self.downButton.updateTheme(theme: theme)
        }
    }
    
    func updateLayout(transition: ContainedViewLayoutTransition) -> CGSize {
        let buttonSize = CGSize(width: 38.0, height: 38.0)
        let completeSize = CGSize(width: buttonSize.width, height: buttonSize.height * 2.0 + 12.0)
        var mentionsOffset: CGFloat = 0.0
        
        if self.displayDownButton {
            mentionsOffset = buttonSize.height + 12.0

            self.downButton.isHidden = false
            transition.updateAlpha(node: self.downButton, alpha: 1.0)
            transition.updateTransformScale(node: self.downButton, scale: 1.0)
        } else {
            transition.updateAlpha(node: self.downButton, alpha: 0.0, completion: { [weak self] completed in
                guard let strongSelf = self, completed else {
                    return
                }
                strongSelf.downButton.isHidden = true
            })
            transition.updateTransformScale(node: self.downButton, scale: 0.2)
        }
        
        if self.mentionCount != 0 {
            self.mentionsButton.isHidden = false
            transition.updateAlpha(node: self.mentionsButton, alpha: 1.0)
            transition.updateTransformScale(node: self.mentionsButton, scale: 1.0)
            self.mentionsButtonTapNode.isHidden = false
        } else {
            transition.updateAlpha(node: self.mentionsButton, alpha: 0.0, completion: { [weak self] completed in
                guard let strongSelf = self, completed else {
                    return
                }
                strongSelf.mentionsButton.isHidden = true
            })
            transition.updateTransformScale(node: self.mentionsButton, scale: 0.2)
            self.mentionsButtonTapNode.isHidden = true
        }
        
        transition.updatePosition(node: self.downButton, position: CGRect(origin: CGPoint(x: 0.0, y: completeSize.height - buttonSize.height), size: buttonSize).center)
        
        transition.updatePosition(node: self.mentionsButton, position: CGRect(origin: CGPoint(x: 0.0, y: completeSize.height - buttonSize.height - mentionsOffset), size: buttonSize).center)
        self.mentionsButtonTapNode.frame = CGRect(origin: CGPoint(x: 0.0, y: completeSize.height - buttonSize.height - mentionsOffset), size: buttonSize)
        
        return completeSize
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let subnodes = self.subnodes {
            for subnode in subnodes {
                if !subnode.isUserInteractionEnabled {
                    continue
                }
                if let result = subnode.hitTest(point.offsetBy(dx: -subnode.frame.minX, dy: -subnode.frame.minY), with: event) {
                    return result
                }
            }
        }
        return nil
    }
    
    @objc private func mentionsTap(_ recognizer: TapLongTapOrDoubleTapGestureRecognizer) {
        if case .ended = recognizer.state, let gesture = recognizer.lastRecognizedGestureAndLocation?.0 {
            if case .tap = gesture {
                self.mentionsPressed?()
            } else if case .longTap = gesture {
                self.mentionsMenu?()
            }
        }
    }

    final class SnapshotState {
        fileprivate let downButtonSnapshotView: UIView?

        fileprivate init(
            downButtonSnapshotView: UIView?
        ) {
            self.downButtonSnapshotView = downButtonSnapshotView
        }
    }

    func prepareSnapshotState() -> SnapshotState {
        var downButtonSnapshotView: UIView?
        if !self.downButton.isHidden {
            downButtonSnapshotView = self.downButton.view.snapshotView(afterScreenUpdates: false)!
        }
        return SnapshotState(
            downButtonSnapshotView: downButtonSnapshotView
        )
    }

    func animateFromSnapshot(_ snapshotState: SnapshotState) {
        if self.downButton.isHidden != (snapshotState.downButtonSnapshotView == nil) {
            if self.downButton.isHidden {
            } else {
                self.downButton.layer.animateAlpha(from: 0.0, to: self.downButton.alpha, duration: 0.3)
                self.downButton.layer.animateScale(from: 0.1, to: 1.0, duration: 0.5, timingFunction: kCAMediaTimingFunctionSpring, removeOnCompletion: true)
            }
        }
    }
}
