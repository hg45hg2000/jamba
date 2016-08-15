//
//  CollectionViewController.h
//  TaipeiTrackRubbishTruck
//
//  Created by CHEN HENG Lin on 2016/8/15.
//  Copyright © 2016年 CENGLIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *_collectionView;
}

@end
