//
//  BPPageContainerLoginDescriptionViewController.swift
//  ios-binners-project
//
//  Created by Matheus Ruschel on 2/2/16.
//  Copyright © 2016 Rodrigo de Souza Reis. All rights reserved.
//

import UIKit

class BPPageContainerLoginDescriptionViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var skipButton: UIButton!
    var pageViewController:UIPageViewController?
    var pageImages = ["page1.pdf","page2.pdf","page3.pdf","page4.pdf"]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectDescriptionPageViewController") as? UIPageViewController
        self.pageViewController!.dataSource = self
        let startingViewController = self.viewControllerAtIndex(0) as! BPPageContentDescriptionLoginViewController
        let viewControllers = [startingViewController]
        
        self.pageViewController?.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        // Change the size of page view controller
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        
        // bring button to front
        self.view.bringSubviewToFront(self.skipButton)
        
        // configure page control
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor =  UIColor.whiteColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as? BPPageContentDescriptionLoginViewController)?.pageIndex
        
        guard var indexUw = index else {
            
            return nil
        }
        
        indexUw++
        if (indexUw == self.pageImages.count) {
            return nil
        }
        return self.viewControllerAtIndex(indexUw)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let index = (viewController as? BPPageContentDescriptionLoginViewController)?.pageIndex
        
        guard var indexUw = index else {
            
            return nil
        }
        
        if (indexUw == 0) {
            return nil;
        }
        
        indexUw--
        return self.viewControllerAtIndex(indexUw)
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController?
    {
        if self.pageImages.count == 0 || index >= self.pageImages.count {
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentDescriptionViewController") as! BPPageContentDescriptionLoginViewController
        
        // Create a new view controller and pass suitable data.

        pageContentViewController.imageFile = self.pageImages[index]
        pageContentViewController.pageIndex = index;
        
        return pageContentViewController;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
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
