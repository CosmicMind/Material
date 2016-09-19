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

import UIKit
import Material
import EventKit

public struct RemindersDataSource {
    /// A reference to an EKCalendar returned from the fetchResult.
    public private(set) var list: EKCalendar
    
    /// A reference to an Array of EKReminders for the EKCalendar.
    public private(set) var items: [EKReminder]
}

class RemindersListViewController: RemindersController {
    /// A collectionView used to display entries.
    internal var collectionView: RemindersListCollectionView!
    
    /// An Array of ReminderDataSource items.
    internal lazy var dataSourceItems = [RemindersDataSource]()
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = Color.grey.lighten5
        
        prepareNavigationItem()
        prepareCollectionView()
        
        reminders.requestAuthorization()
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "Reminders"
        navigationItem.titleLabel.textColor = Color.blueGrey.base
        
        navigationItem.detail = "Lists"
    }
    
    /// Prepares the collectionView.
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width, height: 88)
        
        collectionView = RemindersListCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layout(collectionView).edges()
    }
}

extension RemindersListViewController {
    func reminders(reminders: Reminders, status: RemindersAuthorizationStatus) {
        print("Status", .authorized == status ? "Authorized" : "Denied")
    }
    
    func reminders(authorized reminders: Reminders) {
        fetchLists { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func reminders(denied reminders: Reminders) {
        print("Denied")
    }
    
    func reminders(reminders: Reminders, list: EKCalendar, created: Bool) {
        
    }
    
    func reminders(reminders: Reminders, list: EKCalendar, deleted: Bool) {
        
    }
    
    func reminders(reminders: Reminders, created: Bool) {
        
    }
    
    func reminders(reminders: Reminders, deleted: Bool) {
        
    }
}

extension RemindersListViewController {
    internal func fetchLists(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self, completion = completion] in
            guard let s = self else {
                return
            }
            
            s.reminders.fetchLists { [weak self, completion = completion] (lists) in
                guard let s = self else {
                    return
                }
                
                s.dataSourceItems.removeAll()
                
                let endIndex = lists.count - 1
                for i in 0...endIndex {
                    let list = lists[i]
                    
                    s.reminders.fetchReminders(list: list) { [weak self, completion = completion] (reminders) in
                        guard let s = self else {
                            return
                        }
                        
                        s.dataSourceItems.append(RemindersDataSource(list: list, items: reminders))
                        
                        if i == endIndex {
                            completion()
                        }
                    }
                }
            }
        }
    }
}

/// UICollectionViewDelegate methods.
extension RemindersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(RemindersItemsViewController(dataSource: dataSourceItems[indexPath.section]), animated: true)
    }
}


/// CollectionViewDataSource methods.
extension RemindersListViewController: UICollectionViewDataSource {
    /// Determines the number of items in the collectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSourceItems.count
    }
    
    /// Prepares the cells within the collectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RemindersListCollectionViewCell", for: indexPath) as! RemindersListCollectionViewCell
        
        let dataSource = dataSourceItems[indexPath.section]
        let list = dataSource.list
        let items = dataSource.items
        cell.titleLabel.text = list.title
        cell.titleLabel.textColor = UIColor(cgColor: list.cgColor)
        cell.countLabel.text = "\(items.count)"
        cell.countLabel.textColor = UIColor(cgColor: list.cgColor)
        
        return cell
    }
}

