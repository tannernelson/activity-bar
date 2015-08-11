import UIKit

public class ActivityBar: UIView {
    
    //MARK: Properties
    private var bar = UIView()
    private var barLeft: NSLayoutConstraint!
    private var barRight: NSLayoutConstraint!
    private var animationTimer: NSTimer?
    
    //MARK: Constants
    private let duration: NSTimeInterval = 1
    private let waitTime: NSTimeInterval = 0.5
    
    //MARK: Lifecycle
    private func initializeBar() {
        super.awakeFromNib()
        
        self.bar.backgroundColor = self.color
        self.bar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(self.bar)
        
        //Left and right margins from bar to container
        self.barLeft = NSLayoutConstraint(item: self.bar, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        self.addConstraint(self.barLeft)
        self.barRight = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.bar, attribute: .Right, multiplier: 1, constant: 1)
        self.addConstraint(self.barRight!)
        
        //Align top and bottom of bar to container
        self.addConstraint(
            NSLayoutConstraint(item: self.bar, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: self.bar, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        )
    }
    
    func animate() {
        let toZero: NSLayoutConstraint
        let toWidth: NSLayoutConstraint
        
        if self.barRight.constant == 0 {
            toZero = self.barLeft
            toWidth = self.barRight
            self.barRight.constant = 0
            self.barLeft.constant = self.frame.size.width
        } else {
            toZero = self.barRight
            toWidth = self.barLeft
            self.barRight.constant = self.frame.size.width
            self.barLeft.constant = 0
        }
        self.layoutIfNeeded()
        
        UIView.animateWithDuration(self.duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            toZero.constant = 0
            self.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(self.duration * 0.7, delay: self.duration * 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            toWidth.constant = self.frame.size.width
            self.layoutIfNeeded()
            }, completion:nil)
        
    }
    
    
    //MARK: Public
    public var color = UIColor.blackColor() {
        didSet {
            self.bar.backgroundColor = self.color
        }
    }
    
    public func start() {
        self.stop()
        
        self.barRight.constant = self.frame.size.width - 1
        self.layoutIfNeeded()
        
        self.hidden = false
        
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.duration + self.waitTime, target: self, selector: "animate", userInfo: nil, repeats: true)
        self.animate()
    }
    
    public func stop() {
        self.animationTimer?.invalidate()
        self.animationTimer = nil
    }
    
    //MARK: Class
    public class func addTo(viewController: UIViewController) -> ActivityBar {
        var activityBar = ActivityBar()
        
        activityBar.alpha = 0.8
        
        var topOffset: CGFloat = 20
        
        let view: UIView
        let xLayout: NSLayoutConstraint
        
        if let navigationBar = viewController.navigationController?.navigationBar {
            topOffset += navigationBar.frame.size.height
            
            view = navigationBar
            xLayout = NSLayoutConstraint(item: activityBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -2)
        } else {
            view = viewController.view
            xLayout = NSLayoutConstraint(item: activityBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: topOffset)
        }
        
        activityBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        activityBar.hidden = true
        
        view.addSubview(activityBar)
        
        //Height = 2
        activityBar.addConstraint(
            NSLayoutConstraint(item: activityBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 2)
        )
        
        //Insert view at top with top offset
        view.addConstraint(
            xLayout
        )
        
        //Left and right align view to superview
        view.addConstraint(
            NSLayoutConstraint(item: activityBar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0)
        )
        view.addConstraint(
            NSLayoutConstraint(item: activityBar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0)
        )
        
        activityBar.initializeBar()
        
        activityBar.color = viewController.view.tintColor
        
        return activityBar
    }
    
    
}