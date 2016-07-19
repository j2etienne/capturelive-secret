//
//  CMModalReminderViewController.swift
//  Current
//
//  Created by Scott Jones on 3/31/16.
//  Copyright © 2016 CaptureMedia. All rights reserved.
//

import UIKit
import CoreData
import CaptureModel
import CaptureCore
import CaptureSync
import CoreDataHelpers

class ModalReminder1HourViewController: UIViewController, RemoteAndLocallyServiceable {
   
    var managedObjectContext: NSManagedObjectContext!
    var remoteService: CaptureLiveRemoteType!
    private var observer:ManagedObjectObserver?
    
    var theView:ModalReminder1HourView {
        guard let v = self.view as? ModalReminder1HourView else { fatalError("Not a ModalReminder1HourView!") }
        return v
    }
    
    var notification:Notification! {
        didSet {
            observer = ManagedObjectObserver(object: notification) { [unowned self] type in
                guard type == .Update else {
                    return
                }
                self.updateResponse()
            }
            guard let e = notification.eventSource else { fatalError("Notification has no event") }
            event           = e
            guard let c = notification.contractSource else { fatalError("Notification has no contract") }
            contract        = c
        }
    }
    var event:Event!
    var contract:Contract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theView.didLoad()
        self.theView.populate(event:event.viewModel())
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
    
    func updateResponse() {
        guard let _ = notification.readAt else { return }
        observer                        = nil
        performSegueWithIdentifier("unwindFromReminder1HourModal", sender: self)
    }

    
    // MARK: ADD/REMOVE handles
    func addEventHandlers() {
        self.theView.takeMeThereButton?.addTarget(self, action: #selector(exitAlertModal), forControlEvents: .TouchUpInside)
    }
    
    func removeEventHandlers() {
        self.theView.takeMeThereButton?.removeTarget(self, action: #selector(exitAlertModal), forControlEvents: .TouchUpInside)
    }
   
    
    //MARK: Button handlers
    func exitAlertModal() {
        managedObjectContext.performChanges { [unowned self] in
            self.event.markNotificationAsRead(.JobStartsIn1Hour)
            self.contract.start()
            UIApplication.sharedApplication().updateBadgeNumberForUnreadNotifications(self.managedObjectContext)
        }
    }
    
}
