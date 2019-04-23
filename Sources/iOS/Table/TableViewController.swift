/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public protocol TableViewDelegate: UITableViewDelegate {}

public protocol TableViewDataSource: UITableViewDataSource {
  /**
   Retrieves the data source items for the tableView.
   - Returns: An Array of DataSourceItem objects.
   */
  var dataSourceItems: [DataSourceItem] { get }
}

extension UIViewController {
  /**
   A convenience property that provides access to the TableViewController.
   This is the recommended method of accessing the TableViewController
   through child UIViewControllers.
   */
  public var tableViewController: TableViewController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class TableViewController: ViewController {
  /// A reference to a Reminder.
  public let tableView = TableView()
  
  /// An Array of DataSourceItems.
  open var dataSourceItems = [DataSourceItem]()
  
  open override func prepare() {
    super.prepare()
    prepareTableView()
  }
}

extension TableViewController {
  /// Prepares the tableView.
  fileprivate func prepareTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .clear
    view.layout(tableView).edges()
  }
}

extension TableViewController: TableViewDelegate {}

extension TableViewController: TableViewDataSource {
  @objc
  open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  @objc
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSourceItems.count
  }
  
  @objc
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
