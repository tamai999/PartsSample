//
//  SampleHalfModalView.swift
//  PartsSample
//

import UIKit
import SnapKit

protocol SampleHalfModalViewDelegate: NSObject {
    /// ハーフモーダルの背景（余白）部分をタップされた
    func backgroundDidTap()
    /// ハーフモーダルのタイトル部分のジェスチャーを検知
    func headerGestureRecognized(_ sender: UIPanGestureRecognizer)
    /// TableView自体のジェスチャーを検知
    func tableViewGestureRecognized(_ sender: UIPanGestureRecognizer)
    /// TableViewがスクロールされた
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

fileprivate struct Const {
    static let halfModalHeight: CGFloat = 300.0
    static let headerCornarRadius: CGFloat = 10.0
    static let headerHeight: CGFloat = 60.0
    static let sampleContentNumber = 30
}

class SampleHalfModalView: UIView {
    // MARK: - private properties
    
    private weak var headerView: UIView!
    private weak var headerTitle: UILabel!
    private weak var backgroundView: UIView!
    private weak var tableView: UITableView!
    
    // MARK: - internal properties
    weak var delegate: SampleHalfModalViewDelegate?
    
    // MARK: - lifecycle
    init() {
        super.init(frame: .zero)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal
    
    func setTableViewBounces(_ enable: Bool) {
        tableView.bounces = enable
    }
}

private extension SampleHalfModalView {
    func setupViews() {
        // 背景
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backgroundView.addGestureRecognizer(gesture)
        
        // ヘッダー
        let headerView = UIView()
        headerView.backgroundColor = R.color.background()
        addSubview(headerView)
        self.headerView = headerView
        
        headerView.layer.cornerRadius = Const.headerCornarRadius
        headerView.layer.maskedCorners = [.layerMinXMinYCorner,. layerMaxXMinYCorner]
        let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(headerGestureRecognized(_:)))
        headerView.addGestureRecognizer(headerGesture)
        
        // ヘッダータイトル
        let headerTitle = UILabel()
        headerTitle.text = "ハーフモーダル"
        headerTitle.textColor = R.color.label()
        headerView.addSubview(headerTitle)
        self.headerTitle = headerTitle
        
        // TableView
        let tableView = UITableView()
        let tableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(tableViewGestureRecognized(_:)))
        tableViewGesture.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(tableViewGesture)
        addSubview(tableView)
        self.tableView = tableView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
    }
    
    func layoutViews() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(Const.headerHeight)
            make.top.equalTo(snp.bottom).offset(-Const.halfModalHeight)
        }
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    func backgroundDidTap() {
        delegate?.backgroundDidTap()
    }
    
    @objc
    func headerGestureRecognized(_ sender: UIPanGestureRecognizer) {
        delegate?.headerGestureRecognized(sender)
    }
    
    @objc
    func tableViewGestureRecognized(_ sender: UIPanGestureRecognizer) {
        delegate?.tableViewGestureRecognized(sender)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SampleHalfModalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Const.sampleContentNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className) else {
            fatalError("dequeueReusableCell error")
        }
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SampleHalfModalView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
