//
//  CategoryRow.swift
//  LucidYouTubePlayer
//
//  Created by Darshan Gulur Srinivasa on 5/13/18.
//  Copyright © 2018 Lucid Infosystems. All rights reserved.
//

import UIKit

final class PlaylistRow : UITableViewCell {

    // MARK: - Private properties
    private let flowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        return $0
    }(UICollectionViewFlowLayout())

    private lazy var collectionView: UICollectionView = {
        $0.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: flowLayout))

    private var items = [PlaylistResponse.Item]()
    private var didTapHandler: ((PlaylistResponse.Item) -> Void) = {_ in }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions
    private func addSubViews() {
        self.contentView.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }

    // MARK: - Public functions
    func configure(items: [PlaylistResponse.Item], didTapHandler: @escaping ((PlaylistResponse.Item) -> Void)) {
        self.items = items
        self.didTapHandler = didTapHandler
    }
}

extension PlaylistRow : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell",
                                                      for: indexPath) as! VideoCell
        return cell
    }

}

extension PlaylistRow : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }

}

extension PlaylistRow: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapHandler(items[indexPath.item])
    }
}
