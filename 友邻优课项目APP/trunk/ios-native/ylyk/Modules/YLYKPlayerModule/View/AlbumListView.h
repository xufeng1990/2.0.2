

#import <UIKit/UIKit.h>

@interface AlbumListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _selectWitch;
}

@property (nonatomic,strong) UITableView *courseTableView;
/**
 *  章节总列表
 */
@property (nonatomic,strong) NSMutableArray *linstCourseArray;

/**
 *  每个课程中的内容
 */
@property (nonatomic,strong) NSMutableArray *sectionCourseArray;

/*
 *表头视图
 */
@property (nonatomic,strong) UIView * headerView;

/*
 *表底视图
 */
@property (nonatomic,strong) UIView * footView;

@end
