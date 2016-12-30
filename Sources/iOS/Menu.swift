/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(MenuDirection)
public enum MenuDirection: Int {
    case up
    case down
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

open class MenuItem: Toolbar {
    open override func prepare() {
        super.prepare()
        heightPreset = .normal
        titleLabel.textAlignment = .left
        detailLabel.textAlignment = .left
        contentViewAlignment = .center
    }
}

class MenuCollectionViewCell: CollectionViewCell {
    /// A reference to the MenuItem.
    open var menuItem: MenuItem? {
        didSet {
            oldValue?.removeFromSuperview()
            if let v = menuItem {
                contentView.addSubview(v)
            }
        }
    }
}

@objc(MenuDelegate)
public protocol MenuDelegate {
    /**
     A delegation method that is execited when the menu will open.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuWillOpen(menu: Menu)
    
    /**
     A delegation method that is execited when the menu did open.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuDidOpen(menu: Menu)
    
    /**
     A delegation method that is execited when the menu will close.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuWillClose(menu: Menu)
    
    /**
     A delegation method that is execited when the menu did close.
     - Parameter menu: A Menu.
     */
    @objc
    optional func menuDidClose(menu: Menu)
    
    /**
     A delegation method that is executed when the user taps while
     the menu is opened.
     - Parameter menu: A Menu.
     - Parameter tappedAt point: A CGPoint.
     - Parameter isOutside: A boolean indicating whether the tap
     was outside the menu button area.
     */
    @objc
    optional func menu(menu: Menu, tappedAt point: CGPoint, isOutside: Bool)
    
    @objc
    optional func menu(menu: Menu, didSelect menuItem: MenuItem, at indexPath: IndexPath)
}


@objc(Menu)
open class Menu: Button {
    /// The direction in which the animation opens the menu.
    open var direction = MenuDirection.up {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the collectionViewCard.
    @IBInspectable
    open let collectionViewCard = CollectionViewCard()
    
    /// A preset wrapper around collectionViewCardEdgeInsets.
    open var collectionViewCardEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            collectionViewCardEdgeInsets = EdgeInsetsPresetToValue(preset: collectionViewCardEdgeInsetsPreset)
        }
    }
    
    /// A reference to collectionViewCardEdgeInsets.
    @IBInspectable
    open var collectionViewCardEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /**
     Retrieves the data source items for the collectionView.
     - Returns: An Array of DataSourceItem objects.
     */
    open fileprivate(set) var dataSourceItems: [DataSourceItem] {
        get {
            return collectionViewCard.dataSourceItems
        }
        set(value) {
            collectionViewCard.dataSourceItems = value
        }
    }
    
    /// A reference to the MenuItems.
    open var items = [MenuItem]() {
        didSet {
            dataSourceItems.removeAll()
            
            for item in items {
                dataSourceItems.append(DataSourceItem(data: item, width: item.width, height: item.height))
            }
            
            layoutSubviews()
        }
    }
    
    /// A boolean indicating if the menu is open or not.
    open var isOpened = false
    
    /// An optional delegation handler.
    open weak var delegate: MenuDelegate?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    open override func prepare() {
        super.prepare()
        prepareCollectionViewCard()
        prepareHandler()
    }

    open func reload() {
        if 0 == collectionViewCard.width {
            collectionViewCard.width = Screen.bounds.width - collectionViewCardEdgeInsets.left - collectionViewCardEdgeInsets.right
        }
    }
}

extension Menu {
    /// Prepares the collectionViewCard.
    fileprivate func prepareCollectionViewCard() {
        collectionViewCard.collectionView.delegate = self
        collectionViewCard.collectionView.dataSource = self
        collectionViewCard.collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
    
    /// Prepares the handler.
    fileprivate func prepareHandler() {
        addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
    }
}

extension Menu {
    /**
     Handles the hit test for the Menu and views outside of the Menu bounds.
     - Parameter _ point: A CGPoint.
     - Parameter with event: An optional UIEvent.
     - Returns: An optional UIView.
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isOpened, isEnabled else {
            return super.hitTest(point, with: event)
        }
        
        for v in subviews {
            let p = v.convert(point, from: self)
            if v.bounds.contains(p) {
                delegate?.menu?(menu: self, tappedAt: point, isOutside: false)
                return v.hitTest(p, with: event)
            }
        }
        
        delegate?.menu?(menu: self, tappedAt: point, isOutside: true)
        
        close()
        
        return self.hitTest(point, with: event)
    }
}


extension Menu {
    open func open() {
        guard !isOpened, isEnabled else {
            return
        }
        
        guard nil == collectionViewCard.superview else {
            return
        }
        
        delegate?.menuWillOpen?(menu: self)
        
        switch direction {
        case .up:
            layout(collectionViewCard).bottom().centerHorizontally()
        case .down:
            layout(collectionViewCard).top().centerHorizontally()
        case .topLeft:
            layout(collectionViewCard).topLeft()
        case .topRight:
            layout(collectionViewCard).topRight()
        case .bottomLeft:
            layout(collectionViewCard).bottomLeft()
        case .bottomRight:
            layout(collectionViewCard).bottomRight()
        }
        
        isOpened = true
        
        delegate?.menuDidOpen?(menu: self)
    }
    
    open func close() {
        guard isOpened, isEnabled else {
            return
        }
        
        delegate?.menuWillClose?(menu: self)
        
        collectionViewCard.removeFromSuperview()
        
        isOpened = false
        
        delegate?.menuDidClose?(menu: self)
    }
}

extension Menu {
    /**
     Handler to toggle the Menu opened or closed.
     - Parameter button: A UIButton.
     */
    @objc
    fileprivate func handleToggleMenu(button: UIButton) {
        guard isOpened else {
            open()
            return
        }
        
        close()
    }
}

extension Menu: CollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = collectionViewCard.indexForDataSourceItems[indexPath] as? MenuItem else {
            return
        }
        
        delegate?.menu?(menu: self, didSelect: menuItem, at: indexPath)
    }
}

extension Menu: CollectionViewDataSource {
    @objc
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        
        guard let menuItem = dataSourceItems[indexPath.item].data as? MenuItem else {
            return cell
        }
        
        collectionViewCard.indexForDataSourceItems[indexPath] = menuItem
        
        cell.menuItem = menuItem
        cell.menuItem?.width = cell.width
        
        return cell
    }
}
