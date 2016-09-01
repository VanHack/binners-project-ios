//
//  BPPageContainerLoginDescriptionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/2/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.

import UIKit

protocol PageControlDataSource {
    var pageIndex: Int? {get set}
}

class BPPageContainerLoginDescriptionViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var skipButton: UIButton!
    var pageViewController: UIPageViewController?
    var pages = 3


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDescriptionPageViewController")
            as? UIPageViewController
        
        self.pageViewController!.dataSource = self
        
        let startingViewController = self.viewControllerAtIndex(0)!
        
        let viewControllers = [startingViewController]
        
        self.pageViewController?.setViewControllers(
            viewControllers,
            direction: .Forward,
            animated: true,
            completion: nil)
        
        self.pageViewController!.view.backgroundColor = UIColor.binnersGreenColor()
        
        self.addChildViewController(self.pageViewController!)
        
        self.view.addSubview(self.pageViewController!.view)
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // configure skip button font
        self.skipButton.tintColor = UIColor.binnersSkipButtonColor()
        self.skipButton.titleLabel?.font = UIFont.binnersFont()
        self.view.bringSubviewToFront(self.skipButton)
        
        // configure page control
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.binnersSkipButtonColor()
        pageControl.currentPageIndicatorTintColor =  UIColor.whiteColor()
        pageControl.backgroundColor = UIColor.clearColor()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerAfterViewController
        viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as? PageControlDataSource)?.pageIndex
        
        guard var indexUw = index else {
            
            return nil
        }
        
        indexUw += 1
        if indexUw == self.pages {
            return nil
        }
        return self.viewControllerAtIndex(indexUw)
    }
    
    func pageViewController(
        pageViewController: UIPageViewController,
        viewControllerBeforeViewController
        viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as? PageControlDataSource)?.pageIndex
        
        guard var indexUw = index else {
            
            return nil
        }
        
        if indexUw == self.pages {
            return nil
        }
        
        indexUw -= 1
        return self.viewControllerAtIndex(indexUw)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController?
    {
        
        var pageContentVC: UIViewController?
        
        switch index {
            
        case 0: pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier(
            "PageTwoContentDescriptionViewController")
            as? BPPageTwoContentDescriptionLoginViewController
        case 1: pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier(
            "PageThreeContentDescriptionViewController")
            as? BPPageThreeContentDescriptionLoginViewController
        case 2:  pageContentVC = self.storyboard?.instantiateViewControllerWithIdentifier(
            "PageFourContentDescriptionViewController")
            as? BPPageFourContentDescriptionLoginViewController
        default: pageContentVC = nil
            
        }
        
        if var page = pageContentVC as? PageControlDataSource {
                page.pageIndex = index
        }
        return pageContentVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pages
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
