/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import EventKit

@objc(RemindersAuthorizationStatus)
public enum RemindersAuthorizationStatus: Int {
    case authorized
    case denied
}

@objc(RemindersDelegate)
public protocol RemindersDelegate {
    /**
     A delegation method that is executed when the Reminder status is updated.
     - Parameter reminders: A reference to the Reminder.
     - Parameter status: A reference to the ReminderAuthorizationStatus.
     */
    @objc
    optional func reminders(reminders: Reminders, status: RemindersAuthorizationStatus)
    
    /**
     A delegation method that is executed when Reminders is authorized.
     - Parameter reminders: A reference to the Reminders.
     */
    @objc
    optional func reminders(authorized reminders: Reminders)
    
    /**
     A delegation method that is executed when Reminders is denied.
     - Parameter reminders: A reference to the Reminders.
     */
    @objc
    optional func reminders(denied reminders: Reminders)
    
    /**
     A delegation method that is executed when a new Reminders list is created
     - Parameter reminders: A reference to the Reminders.
     - Parameter list: A reference to the calendar created
     - Parameter created: A boolean describing if the operation succeeded or not.
     */
    @objc
    optional func reminders(reminders: Reminders, list: EKCalendar, created: Bool)
    
    /**
     A delegation method that is executed when a new Reminders list is created
     - Parameter reminders: A reference to the Reminder.
     - Parameter list: A reference to the calendar created
     - Parameter deleted: A boolean describing if the operation succeeded or not.
     */
    @objc
    optional func reminders(reminders: Reminders, list: EKCalendar, deleted: Bool)
    
    /**
     A delegation method that is executed when a new Reminders list is created
     - Parameter reminders: A reference to the Reminder.
     - Parameter created: A boolean describing if the operation succeeded or not.
     */
    @objc
    optional func reminders(reminders: Reminders, created: Bool)
    
    /**
     A delegation method that is executed when a new Reminders list is created
     - Parameter reminders: A reference to the Reminder.
     - Parameter deleted: A boolean describing if the operation succeeded or not.
     */
    @objc
    optional func reminders(reminders: Reminders, deleted: Bool)
}

@objc(Reminders)
open class Reminders: NSObject {
    /// The current ReminderAuthorizationStatus.
    public var authorizationStatus: RemindersAuthorizationStatus {
        return .authorized == EKEventStore.authorizationStatus(for: .reminder) ? .authorized : .denied
    }
    
    /// A reference to the eventStore.
    internal lazy var eventStore = EKEventStore()
    
    /// A reference to a RemindersDelegate.
    open weak var delegate: RemindersDelegate?
    
    open func requestAuthorization(_ completion: ((RemindersAuthorizationStatus) -> Void)? = nil) {
        eventStore.requestAccess(to: .reminder) { [weak self, completion = completion] (permission, _) in
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                if permission {
                    s.delegate?.reminders?(reminders: s, status: .authorized)
                    s.delegate?.reminders?(authorized: s)
                    completion?(.authorized)
                } else {
                    s.delegate?.reminders?(reminders: s, status: .denied)
                    s.delegate?.reminders?(denied: s)
                    completion?(.denied)
                }
            }
        }
    }
}

// List CRUD operations
extension Reminders {
    
    /**
     A method for creating new Reminder lists
     - Parameter list title: the name of the list
     - Parameter completion: optional completion call back
     */
    public func create(list title: String, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let list = EKCalendar(for: .reminder, eventStore: s.eventStore)
            list.title = title
            
            for source in s.eventStore.sources {
                if .local == source.sourceType {
                    list.source = source
                    
                    var created = false
                    var error: Error?
                    
                    do {
                        try s.eventStore.saveCalendar(list, commit: true)
                        created = true
                    } catch let e {
                        error = e
                    }
                    
                    DispatchQueue.main.async { [weak self, completion = completion] in
                        guard let s = self else {
                            return
                        }
                        s.delegate?.reminders?(reminders: s, list: list, created: created)
                        completion?(created, error)
                    }
                }
            }
        }
    }
    
    /**
     A method for deleting existing Reminder lists
     - Parameter list identifier: the name of the list
     - Parameter completion: optional completion call back
     */
    public func delete(list identifier: String, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            guard let list = s.eventStore.calendar(withIdentifier: identifier) else {
                return
            }
            
            var deleted = false
            var error: Error?
            
            do {
                try s.eventStore.removeCalendar(list, commit: true)
                deleted = true
            } catch let e {
                error = e
            }
            
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                s.delegate?.reminders?(reminders: s, list: list, deleted: deleted)
                completion?(deleted, error)
            }
        }
    }
    
    /**
     A method for retrieving reminder lists
     - Parameter completion: completion call back
     */
    public func fetchLists(completion: ([EKCalendar]) -> Void) {
        completion(eventStore.calendars(for: .reminder))
    }
}

// Reminder list CRUD operations
extension Reminders {
    
    /**
     A method for retrieving reminders from an optionally existing list.
     if the list does not exist the reminders will be retrieved from the default reminders list
     - Parameter list: An optional EKCalendar.
     - Parameter completion: completion call back
     */
    public func fetchReminders(list: EKCalendar, completion: @escaping ([EKReminder]) -> Void) {
        var lists = [EKCalendar]()
        lists.append(list)
        
        eventStore.fetchReminders(matching: eventStore.predicateForReminders(in: lists)) { [completion = completion] (reminders) in
            DispatchQueue.main.async { [completion = completion] in
                completion(reminders ?? [])
            }
        }
    }
    
    // FIX ME: Should we use the calendar identifier here instead of the title for finding the right cal?
    /**
     A method for adding a new reminder to an optionally existing list.
     if the list does not exist it will be added to the default reminders list.
     - Parameter completion: optional completion call back
     */
    public func create(title: String, dateComponents: DateComponents, in list: EKCalendar? = nil, completion: ((Error?) -> Void)? = nil) {
        var reminderCal = [EKCalendar]()
        
        if list != nil {
            fetchLists(completion: { (calendars) in
                for calendar in calendars {
                    if calendar.title == list!.title {
                        reminderCal.append(calendar)
                    }
                }
            })
        }
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.dueDateComponents = dateComponents
        reminder.calendar = reminderCal.last!
        
        var created: Bool = false
        var error: Error?
        
        do {
            try eventStore.save(reminder, commit: true)
            created = true
        } catch let e {
            error = e
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let s = self else {
                return
            }
            
            s.delegate?.reminders?(reminders: s, created: created)
            
            if let c = completion {
                c(error)
            }
        }
    }
    
    // FIX ME: Should we use the calendar identifier here instead of the title for finding the right cal?
    /**
     A method for adding a new reminder to an optionally existing list.
     if the list does not exist it will be added to the default reminders list.
     - Parameter completion: optional completion call back
     */
    public func delete(reminder: EKReminder, completion: ((Error?) -> Void)? = nil) {
        var deleted: Bool = false
        var error: Error?
        do {
            try eventStore.remove(reminder, commit: true)
            deleted = true
        } catch let e {
            error = e
        }
        DispatchQueue.main.async { [weak self] in
            guard let s = self else {
                return
            }
            
            s.delegate?.reminders?(reminders: s, deleted: deleted)
            
            if let c = completion {
                c(error)
            }
        }
    }
}
