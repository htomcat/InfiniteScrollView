//
//  THTopViewController.swift
//  InfiniteScrollView
//
//  Created by 浜田　智史 on 2017/04/15.
//  Copyright © 2017年 htomcat. All rights reserved.
//

import UIKit

final class THTopViewController: UIViewController {

    // MARK: - Properties
    private lazy var scollView: UIScrollView = self.createScrollView()
    private lazy var contentsView: UIView = self.createContentsView()
    private lazy var sampleView1: UIView = self.createSampleView()
    private lazy var sampleView2: UIView = self.createSampleView()
    private lazy var sampleView3: UIView = self.createSampleView()
    private var views = [UIView]()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scollView)
        scollView.addSubview(contentsView)
        
        // Set Element to Array
        views = [sampleView1, sampleView2, sampleView3]
        for view in views {
            contentsView.addSubview(view)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutScrollView()
        layoutContentsView()
        layoutSampleViews()
    }

    // MARK: - Instance Methods
    private func createScrollView() -> UIScrollView {
        let _scrollView = UIScrollView(frame: .zero)
        _scrollView.translatesAutoresizingMaskIntoConstraints = false
        _scrollView.backgroundColor = UIColor.white
        _scrollView.isPagingEnabled = true
        _scrollView.delegate = self
        return _scrollView
    }
    private func layoutScrollView() {
        let views: [String: Any] = ["topLayoutGuide": topLayoutGuide,
                                    "scrollView": scollView,
                                    "bottomLayoutGuide": bottomLayoutGuide]
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-padding-|",
                                                        options: [],
                                                        metrics: ["padding": -20],
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[topLayoutGuide]-0-[scrollView]-0-[bottomLayoutGuide]-|", options: [],
                                                      metrics: nil,
                                                      views: views)
        view.addConstraints(horizontal)
        view.addConstraints(vertical)
    }
    private func createContentsView() -> UIView {
        let _contentsView = UIView(frame: .zero)
        _contentsView.translatesAutoresizingMaskIntoConstraints = false
        return _contentsView
    }
    private func layoutContentsView() {
        let views: [String: Any] = ["contentsView": contentsView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentsView]-0-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentsView]-0-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        let height = NSLayoutConstraint(item: contentsView,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: .height,
                                       multiplier: 1.0,
                                       constant: -20.0)
        view.addConstraint(height)
        scollView.addConstraints(horizontal)
        scollView.addConstraints(vertical)
    }
    private func createSampleView() -> UIView {
        let _sampleView = UIView(frame: .zero)
        _sampleView.translatesAutoresizingMaskIntoConstraints = false
        _sampleView.backgroundColor = UIColor.blue
        return _sampleView
    }
    private func layoutSampleViews() {
        var tmpViewsArray = [String: UIView]()
        for (index, view) in views.enumerated() {
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["view": view])
            contentsView.addConstraints(vertical)
            tmpViewsArray["view\(index)"] = view
        }
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view0(width)]-padding-[view1(width)]-padding-[view2(width)]-padding-|",
                                                        options: [],
                                                        metrics: ["width": UIScreen.main.bounds.width,
                                                                  "padding": 20],
                                                        views: tmpViewsArray)
        contentsView.addConstraints(horizontal)
    }
}
extension THTopViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if scrollView.contentOffset.x > UIScreen.main.bounds.width / 2{
        //    scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width + 20, y: 0), animated: false)
        //}
    }
}
