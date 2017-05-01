//
//  THTopViewController.swift //  InfiniteScrollView
//
//  Created by htomcat on 2017/04/15.
//  Copyright © 2017年 htomcat. All rights reserved.
//

import UIKit

final class THTopViewController: UIViewController {

    // MARK: - Type Properties
    static let padding: CGFloat = 20

    // MARK: - Instance Properties
    fileprivate lazy var scollView: UIScrollView = self.createScrollView()
    fileprivate lazy var contentsView: UIView = self.createContentsView()
    fileprivate var contentsViews = [UIView]()
    fileprivate var appearViews = [UIView]()
    fileprivate var currentIndex: Int = 0
    fileprivate var maxPageIndex: Int {
        return self.contentsViews.count - 1
    }
    // MARK: - Initializer
    init?(views: [UIView]) {
        contentsViews = views
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scollView)
        scollView.addSubview(contentsView)
        
        // Set Element to Array
        guard let lastView = contentsViews.last else {
            return
        }
        let firstView: UIView = contentsViews[0]
        let secondView: UIView = contentsViews[1]
        appearViews = [lastView, firstView, secondView]
        for view in appearViews {
            contentsView.addSubview(view)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scollView.removeConstraints(scollView.constraints)
        contentsView.removeConstraints(contentsView.constraints)
        
        layoutScrollView()
        layoutContentsView()
        layoutSampleViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scollView.contentOffset.x = UIScreen.main.bounds.width + type(of: self).padding
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
                                                        metrics: ["padding": -type(of: self).padding],
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
                                       constant: -type(of: self).padding)
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
        var visualFormat = "H:|-0-"
        for (index, view) in appearViews.enumerated() {
            let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                          options: [],
                                                          metrics: nil,
                                                          views: ["view": view])
            contentsView.addConstraints(vertical)
            tmpViewsArray["view\(index)"] = view
            visualFormat += "[view\(index)(width)]-padding-"
        }
        visualFormat += "|"
        
        //let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view0(width)]-padding-[view1(width)]-padding-[view2(width)]-padding-|",
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                        options: [],
                                                        metrics: ["width": UIScreen.main.bounds.width,
                                                                  "padding": type(of: self).padding],
                                                        views: tmpViewsArray)
        contentsView.addConstraints(horizontal)
    }
}
extension THTopViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == (UIScreen.main.bounds.width + type(of: self).padding) * 2 {
            currentIndex += 1
            if currentIndex > maxPageIndex {
                currentIndex = 0
            }
        } else if scrollView.contentOffset.x == 0 {
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = maxPageIndex
            }
        } else {
            return
        }
        if currentIndex == maxPageIndex {
            appearViews = [contentsViews[currentIndex-1], contentsViews[currentIndex], contentsViews[0]]
        } else if currentIndex == 0 {
            appearViews = [contentsViews[maxPageIndex], contentsViews[currentIndex], contentsViews[currentIndex+1]]
        } else {
            appearViews = [contentsViews[currentIndex-1], contentsViews[currentIndex], contentsViews[currentIndex+1]]
        }
        
        contentsView.subviews.forEach({ subview in
            subview.removeFromSuperview()
        })
        appearViews.forEach({ view in
            self.contentsView.addSubview(view)
        })
        view.setNeedsLayout()
        view.layoutIfNeeded()
        scollView.contentOffset.x = UIScreen.main.bounds.width + type(of: self).padding
    }
}
