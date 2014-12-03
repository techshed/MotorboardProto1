//
//  ViewController.swift
//  MotorboardProto1
//
//  Created by Pete Petrash on 11/28/14.
//  Copyright (c) 2014 Pete Petrash. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    

    var pageViewController = UIPageViewController()
    var mask = UIView()
    var maskButton = UIButton()
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var pageTitles: [String] = ["Save time and money", "On-site delivery", "Buy online, pick up in store", "Purchase tracking and eReceipts"]
    var currentIndex: Int = 0
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func signupButton(sender: AnyObject) {
        showSignUpModal()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.hidden = true
        
        // setup page view controller
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        let startingViewController: PageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 75);
        self.addChildViewController(self.pageViewController)
        self.view.insertSubview(self.pageViewController.view, atIndex: 1)
        self.pageViewController.didMoveToParentViewController(self)
        
        // customize the appearance of page indicators
        var pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.backgroundColor = UIColor.clearColor()
        
        // init mask and maskButton
        initMask()
        
        var signUpViewScaleHide = CGAffineTransformMakeScale(0.8, 0.8)
        var signUpViewTranslateHide = CGAffineTransformMakeTranslation(0, -300)
        self.signUpView.transform = CGAffineTransformConcat( signUpViewScaleHide, signUpViewTranslateHide )
        self.signUpView.alpha = 0
        
        showSignUpModal()
        
    }
    
    func initMask() {
        mask.frame = self.view.bounds
        mask.hidden = true
        mask.alpha = 0
        mask.backgroundColor = UIColor.blackColor()
        insertBlurView(mask, UIBlurEffectStyle.Dark)
        
        maskButton.frame = view.bounds
        maskButton.addTarget(self, action: "hideSignUpModal", forControlEvents: .TouchUpInside)
        maskButton.hidden = true
        
        self.view.insertSubview(mask, atIndex: 2)
        self.view.insertSubview(maskButton, aboveSubview: mask)
    }
    
    func showMask() {
        mask.hidden = false
        maskButton.hidden = false
        
        spring(0.5){
            self.mask.alpha = 1
        }
    }
    
    func hideMask() {
        springWithCompletion(0.5, {
            self.mask.alpha = 0
            }, { finish in
                self.mask.hidden = true
                self.maskButton.hidden = true
        })
        
    }
    
    func showSignUpModal() {
        // init blur mask and maskButton
        showMask()
        
        nameTextField.becomeFirstResponder()
        
        
        
        spring(0.5){
            // scale back walkthrough
            var scale = CGAffineTransformMakeScale(0.8, 0.8)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.pageViewController.view.transform = CGAffineTransformConcat( scale, translate )
            
            // show signup dialog
            self.signUpView.hidden = false
            
            var signUpViewScaleShow = CGAffineTransformMakeScale(1, 1)
            var signUpViewTranslateShow = CGAffineTransformMakeTranslation(0, 0)
            self.signUpView.transform = CGAffineTransformConcat( signUpViewScaleShow, signUpViewTranslateShow )
            self.signUpView.alpha = 1
            
        }
    }
    
    func hideSignUpModal() {
        hideMask()
        
        // hide keyboard
        self.view.endEditing(true)
        
        spring(0.5){
            // scale back walkthrough
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.pageViewController.view.transform = CGAffineTransformConcat( scale, translate )
            
            var signUpViewScaleHide = CGAffineTransformMakeScale(0.8, 0.8)
            var signUpViewTranslateHide = CGAffineTransformMakeTranslation(0, -300)
            self.signUpView.transform = CGAffineTransformConcat( signUpViewScaleHide, signUpViewTranslateHide )
            self.signUpView.alpha = 0
        }
    }
    
    
    
    
    
    
    // instantiate the previous view relative to the current view, if there is one
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as PageContentViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        println("Decreasing Index: \(index)")
        return self.viewControllerAtIndex(index)
    }
    
    // instantiate the next view relative to the current view, if there is one
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as PageContentViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        index++
        
        println("Increasing Index: \(index)")
        
        if (index == self.pageTitles.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    func viewControllerAtIndex(index: Int) -> PageContentViewController?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        
        // Create a new view controller using storyboard and the data
        let pageContentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageContentViewController") as PageContentViewController
        
        // set this view's titleText from pageTitles array
        pageContentViewController.titleText = self.pageTitles[index]
        // set this view's index
        pageContentViewController.pageIndex = index
        self.currentIndex = index
        
        return pageContentViewController
    }
    
    // Set the number of dots in the page indicator according to # of pageTitles in array.
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    // Start the page indicator at the beginning.
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    
    
}

