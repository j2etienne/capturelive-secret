//
//  JobHistoryViewController.swift
//  CaptureLive
//
//  Created by Scott Jones on 5/31/16.
//  Copyright © 2016 Capture Media. All rights reserved.
//

import UIKit

class JobHistoryViewController: UIViewController {
    
    var theView:JobHistoryView {
        guard let v = self.view as? JobHistoryView else { fatalError("Not a JobHistoryView!") }
        return v
    }
    
    private typealias Data = DefaultDataProvider<JobHistoryViewController>
    private var dataSource: TableViewDataSource<JobHistoryViewController, Data, EndedJobTableViewCell>!
    private var dataProvider: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let events = [
            EventTableCellViewModel(
                 urlHash                : "barf"
                ,titleString            : "Burning MAN 2016 Opening Ceremony"
                ,organizationNameString : "The Huffington Post"
                ,organizationLogoPath   : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,bannerImagePath        : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,startDateString        : NSDate().hoursFromNow(11).timeTilString()
                ,hasStartedBool         : true
                ,radiusDouble           : 2.5
                ,distanceAwayDouble     : 2.0
                ,contractStatus         : .NONE
                ,paymentAmountFloat     : 100.00
                ,paymentStatusString    : nil
                ,isCancelledBool        : true
                ,completionDate         : NSDate()
            )
            ,
            EventTableCellViewModel(
                 urlHash                : "barf"
                ,titleString            : "NOW NOW NOW NOW"
                ,organizationNameString : "CNN"
                ,organizationLogoPath   : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,bannerImagePath        : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,startDateString        : NSDate().hoursFromNow(-1).timeTilString()
                ,hasStartedBool         : true
                ,radiusDouble           : 2.5
                ,distanceAwayDouble     : 2.0
                ,contractStatus         : .NONE
                ,paymentAmountFloat     : 100.00
                ,paymentStatusString    : "PENDING"
                ,isCancelledBool        : false
                ,completionDate         : NSDate().hoursFromNow(-0.2)

            )
            ,
            EventTableCellViewModel(
                 urlHash                : "barf"
                ,titleString            : "ALL DAY CHUGFEST, WITH A LONG ASS TITLE. WILL SURELY EFF THINGS UP FOR SURE. TURLEY EVENALL DAY CHUGFEST, WITH A LONG ASS TITLE. WILL SURELY EFF THINGS UP FOR SURE. TURLEY EVEN"
                ,organizationNameString : "CaptureLIVE"
                ,organizationLogoPath   : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,bannerImagePath        : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,startDateString        : NSDate().hoursFromNow(20).timeTilString()
                ,hasStartedBool         : true
                ,radiusDouble           : 2.5
                ,distanceAwayDouble     : 2.0
                ,contractStatus         : .APPLIED
                ,paymentAmountFloat     : 100.00
                ,paymentStatusString    : "PAID"
                ,isCancelledBool        : false
                ,completionDate         : NSDate().hoursFromNow(-3)

            )
            ,
            EventTableCellViewModel(
                 urlHash                : "barf"
                ,titleString            : "Disney on Fire"
                ,organizationNameString : "CNN"
                ,organizationLogoPath   : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,bannerImagePath        : "https://en.gravatar.com/userimage/46582550/d2b7a43025e76943731d65b055868695.jpg?size=200"
                ,startDateString        : NSDate().hoursFromNow(40).timeTilString()
                ,hasStartedBool         : false
                ,radiusDouble           : 2.5
                ,distanceAwayDouble     : 1.0
                ,contractStatus         : .ACQUIRED
                ,paymentAmountFloat     : 100.00
                ,paymentStatusString    : nil
                ,isCancelledBool        : true
                ,completionDate         : NSDate().hoursFromNow(-3000)
            )
        ]
        
        theView.didLoad()
        dataProvider                        = DefaultDataProvider(items:events, delegate :self)
        dataSource                          = TableViewDataSource(tableView:theView.tableView!, dataProvider: dataProvider, delegate:self)
        theView.tableView?.delegate         = self
        
        theView.zeroStateView?.animateOut()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addEventHandlers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeEventHandlers()
    }
    
    // MARK: ADD/REMOVE handles
    func addEventHandlers() {
        theView.backButton?.addTarget(self, action:#selector(back), forControlEvents: .TouchUpInside)
    }
    
    func removeEventHandlers() {
        theView.backButton?.removeTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
    }
    
    func back() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

extension JobHistoryViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EndedJobTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        theView.tableView?.hidden = true
        theView.zeroStateView?.animateIn()
    }
    
}

extension JobHistoryViewController : DataProviderDelegate {
    func dataProviderDidUpdate(updates:[DataProviderUpdate<EventTableCellViewModel>]?) {
        dataSource.processUpdates(updates)
    }
}

extension JobHistoryViewController : DataSourceDelegate {
    func cellIdentifierForObject(object:EventTableCellViewModel) -> String {
        return EndedJobTableViewCell.Identifier
    }
}