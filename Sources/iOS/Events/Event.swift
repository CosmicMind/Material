/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(EventReminderAuthorizationStatus)
public enum EventReminderAuthorizationStatus: Int {
    case authorized
    case denied
}

@objc(EventReminderPriority)
public enum EventReminderPriority: Int {
    case none
    case high = 1
    case medium = 5
    case low = 9
}

@objc(EventDelegate)
public protocol EventDelegate {
    /**
     A delegation method that is executed when the Reminders status is updated.
     - Parameter event: A reference to the Reminders.
     - Parameter status: A reference to the EventReminderAuthorizationStatus.
     */
    @objc
    optional func event(event: Event, status: EventReminderAuthorizationStatus)
    
    /**
     A delegation method that is executed when event authorization is authorized.
     - Parameter event: A reference to the Reminders.
     */
    @objc
    optional func event(authorized event: Event)
    
    /**
     A delegation method that is executed when event authorization is denied.
     - Parameter event: A reference to the Reminders.
     */
    @objc
    optional func event(denied event: Event)
    
    /**
     A delegation method that is executed when a new calendar is created
     - Parameter event: A reference to the Reminders.
     - Parameter calendar: An optional reference to the calendar created.
     - Parameter error: An optional error if the calendar failed to be created.
     */
    @objc
    optional func event(event: Event, createdCalendar calendar: EKCalendar?, error: Error?)
    
    /**
     A delegation method that is executed when a new calendar is created.
     - Parameter event: A reference to the Reminders.
     - Parameter removed calendar: A reference to the calendar created.
     - Parameter error: An optional error if the calendar failed to be removed.
     */
    @objc
    optional func event(event: Event, removedCalendar calendar: EKCalendar, error: Error?)
    
    /**
     A delegation method that is executed when a new reminder is created.
     - Parameter event: A reference to the Reminders.
     - Parameter calendar: An optional reference to the reminder created.
     - Parameter error: An optional error if the reminder failed to be created.
     */
    @objc
    optional func event(event: Event, createdReminders reminder: EKReminder?, error: Error?)
    
    /**
     A delegation method that is executed when a new Reminders list is created
     - Parameter event: A reference to the Reminders.
     - Parameter deleted: A boolean describing if the operation succeeded or not.
     - Parameter error: An optional error if the reminder failed to be removed.
     */
    @objc
    optional func event(event: Event, removedReminders reminder: EKReminder, error: Error?)
}

@objc(Event)
open class Event: NSObject {
    /// A reference to the eventStore.
    fileprivate let store = EKEventStore()
    
    /// The current EventReminderAuthorizationStatus.
    open var authorizationStatus: EventReminderAuthorizationStatus {
        return .authorized == EKEventStore.authorizationStatus(for: .reminder) ? .authorized : .denied
    }
    
    /// A reference to a RemindersDelegate.
    open weak var delegate: EventDelegate?
    
    open func requestRemindersAuthorization(_ completion: ((EventReminderAuthorizationStatus) -> Void)? = nil) {
        store.requestAccess(to: .reminder) { [weak self, completion = completion] (isAuthorized, _) in
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                guard isAuthorized else {
                    completion?(.denied)
                    s.delegate?.event?(event: s, status: .denied)
                    s.delegate?.event?(denied: s)
                    return
                }
                
                completion?(.authorized)
                s.delegate?.event?(event: s, status: .authorized)
                s.delegate?.event?(authorized: s)
            }
        }
    }
}

extension Event {
    /**
     Creates a predicate for the event Array of calendars.
     - Parameter in calendars: An optional Array of EKCalendars.
     */
    open func predicateForReminders(in calendars: [EKCalendar]) -> NSPredicate {
        return store.predicateForReminders(in: calendars)
    }
    
    /**
     Creates a predicate for the event Array of calendars that
     are incomplete and have a given start and end date.
     - Parameter starting: A Date.
     - Parameter ending: A Date.
     - Parameter calendars: An optional Array of [EKCalendar].
     */
    open func predicateForIncompleteReminders(starting: Date, ending: Date, calendars: [EKCalendar]? = nil) -> NSPredicate {
        return store.predicateForIncompleteReminders(withDueDateStarting: starting, ending: ending, calendars: calendars)
    }
    
    /**
     Creates a predicate for the event Array of calendars that
     are completed and have a given start and end date.
     - Parameter starting: A Date.
     - Parameter ending: A Date.
     - Parameter calendars: An optional Array of [EKCalendar].
     */
    open func predicateForCompletedReminders(starting: Date, ending: Date, calendars: [EKCalendar]? = nil) -> NSPredicate {
        return store.predicateForCompletedReminders(withCompletionDateStarting: starting, ending: ending, calendars: calendars)
    }
}

extension Event {
    /**
     A method for retrieving reminder calendars in alphabetical order.
     - Parameter completion: A completion call back
     */
    open func calendarsForReminders(completion: @escaping ([EKCalendar]) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let calendar = s.store.calendars(for: .reminder).sorted(by: { (a, b) -> Bool in
                return a.title < b.title
            })
            
            DispatchQueue.main.async { [calendar = calendar, completion = completion] in
                completion(calendar)
            }
        }
    }
    
    /**
     A method for retrieving events with a predicate in date sorted order.
     - Parameter predicate: A NSPredicate.
     - Parameter completion: A completion call back.
     - Returns: A fetch event request identifier.
     */
    @discardableResult
    open func reminders(matching predicate: NSPredicate, completion: @escaping ([EKReminder]) -> Void) -> Any {
        return store.fetchReminders(matching: predicate, completion: { [completion = completion] (event) in
            DispatchQueue.main.async { [completion = completion] in
                completion(event ?? [])
            }
        })
    }
    
    /**
     Fetch all the event in a given Array of calendars.
     - Parameter in calendars: An Array of EKCalendars.
     - Parameter completion: A completion call back.
     - Returns: A fetch event request identifier.
     */
    @discardableResult
    open func reminders(in calendars: [EKCalendar], completion: @escaping ([EKReminder]) -> Void) -> Any {
        return reminders(matching: predicateForReminders(in: calendars), completion: completion)
    }
    
    /**
     Fetch all the event in a given Array of calendars that
     are incomplete, given a start and end date.
     - Parameter starting: A Date.
     - Parameter ending: A Date.
     - Parameter calendars: An Array of EKCalendars.
     - Parameter completion: A completion call back.
     - Returns: A fetch event request identifier.
     */
    @discardableResult
    open func incompleteReminders(starting: Date, ending: Date, calendars: [EKCalendar]? = nil, completion: @escaping ([EKReminder]) -> Void) -> Any {
        return reminders(matching: predicateForIncompleteReminders(starting: starting, ending: ending, calendars: calendars), completion: completion)
    }
    
    /**
     Fetch all the event in a given Array of calendars that
     are completed, given a start and end date.
     - Parameter starting: A Date.
     - Parameter ending: A Date.
     - Parameter calendars: An Array of EKCalendars.
     - Parameter completion: A completion call back.
     - Returns: A fetch event request identifier.
     */
    @discardableResult
    open func completedReminders(starting: Date, ending: Date, calendars: [EKCalendar]? = nil, completion: @escaping ([EKReminder]) -> Void) -> Any {
        return reminders(matching: predicateForCompletedReminders(starting: starting, ending: ending, calendars: calendars), completion: completion)
    }
    
    /**
     Cancels an active event request.
     - Parameter _ identifier: An identifier.
     */
    open func cancel(_ identifier: Any) {
        store.cancelFetchRequest(identifier)
    }
}

extension Event {
    /**
     A method for creating new Reminders calendar.
     - Parameter calendar title: the name of the list.
     - Parameter completion: An optional completion call back.
     */
    open func createCalendarForReminders(title: String, completion: ((EKCalendar?, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            let calendar = EKCalendar(for: .reminder, eventStore: s.store)
            calendar.title = title
            
            calendar.source = s.store.defaultCalendarForNewReminders().source
                    
            var success = false
            var error: Error?
            
            do {
                try s.store.saveCalendar(calendar, commit: true)
                success = true
            } catch let e {
                error = e
            }
            
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                completion?(success ? calendar : nil, error)
                s.delegate?.event?(event: s, createdCalendar: success ? calendar : nil, error: error)
            }
        }
    }
    
    /**
     A method for removing existing calendar,
     - Parameter calendar identifier: The EKCalendar identifier String.
     - Parameter completion: An optional completion call back.
     */
    open func removeCalendar(identifier: String, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            var success = false
            var error: Error?
            
            guard let calendar = s.store.calendar(withIdentifier: identifier) else {
                var userInfo = [String: Any]()
                userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix remove calendar with identifier \(identifier).]"
                userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix remove calendar with identifier \(identifier).]"
                error = NSError(domain: "com.cosmicmind.material.event", code: 0001, userInfo: userInfo)
                
                completion?(success, error)
                return
            }
            
            do {
                try s.store.removeCalendar(calendar, commit: true)
                success = true
            } catch let e {
                error = e
            }
            
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                completion?(success, error)
                s.delegate?.event?(event: s, removedCalendar: calendar, error: error)
            }
        }
    }
}

extension Event {    
    // FIX ME: Should we use the calendar identifier here instead of the title for finding the right cal?
    /**
     A method for adding a new reminder to an optionally existing list.
     if the list does not exist it will be added to the default event list.
     - Parameter completion: optional A completion call back
     */
    open func createReminder(title: String, calendar: EKCalendar, startDateComponents: DateComponents? = nil, dueDateComponents: DateComponents? = nil, priority: EventReminderPriority? = .none, notes: String?, completion: ((EKReminder?, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, calendar = calendar, completion = completion] in
            guard let s = self else {
                return
            }
            
            let reminder = EKReminder(eventStore: s.store)
            reminder.title = title
            reminder.calendar = calendar
            reminder.startDateComponents = startDateComponents
            reminder.dueDateComponents = dueDateComponents
            reminder.priority = priority?.rawValue ?? EventReminderPriority.none.rawValue
            reminder.notes = notes
            
            var success = false
            var error: Error?
            
            do {
                try s.store.save(reminder, commit: true)
                success = true
            } catch let e {
                error = e
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let s = self else {
                    return
                }
                
                completion?(success ? reminder : nil, error)
                s.delegate?.event?(event: s, createdReminders: success ? reminder : nil, error: error)
            }
        }
    }

    /**
     A method for removing existing reminder,
     - Parameter reminder identifier: The EKReminders identifier String.
     - Parameter completion: An optional completion call back.
     */
    open func removeReminder(identifier: String, completion: ((Bool, Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            var success = false
            var error: Error?
            
            guard let reminder = s.store.calendarItem(withIdentifier: identifier) as? EKReminder else {
                var userInfo = [String: Any]()
                userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix remove calendar with identifier \(identifier).]"
                userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix remove calendar with identifier \(identifier).]"
                error = NSError(domain: "com.cosmicmind.material.event", code: 0001, userInfo: userInfo)
                
                completion?(success, error)
                return
            }
            
            do {
                try s.store.remove(reminder, commit: true)
                success = true
            } catch let e {
                error = e
            }
            
            DispatchQueue.main.async { [weak self, completion = completion] in
                guard let s = self else {
                    return
                }
                
                completion?(success, error)
                s.delegate?.event?(event: s, removedReminders: reminder, error: error)
            }
        }
    }
}
