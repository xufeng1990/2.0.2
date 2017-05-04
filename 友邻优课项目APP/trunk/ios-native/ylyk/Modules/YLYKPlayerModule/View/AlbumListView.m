

#import "AlbumListView.h"
#import "AlbumTableViewCell.h"

@implementation AlbumListView

@synthesize courseTableView = _courseTableView;

static NSString *collectionIdenftifier = @"cell";

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectWitch = -100;
        _linstCourseArray = [[NSMutableArray alloc] init];
        _sectionCourseArray  = [[NSMutableArray alloc] init];
        self.frame = frame;
        self.backgroundColor = [UIColor redColor];
        [self loadView];
    }
    return self;
}

#pragma mark -初始化界面
- (void) loadView {
    _courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44-49) style:UITableViewStylePlain];
    _courseTableView.delegate = self;
    _courseTableView.dataSource = self;
//    [_courseTableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:collectionIdenftifier];
    _courseTableView.backgroundColor = [UIColor clearColor];
    _courseTableView.rowHeight = 60;
    [self addSubview:_courseTableView];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.headerView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.headerView];
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 49)];
    self.footView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.footView];
}

#pragma mark -tableView Dlegate dataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell * cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.frame = CGRectMake(0, 0, self.frame.size.width, 60);
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
         cell.teacherName.text = @"dsa";
    }
    cell.teacherName.text = @"dsa";
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    YLCourseHeaderView  *header = [[YLCourseHeaderView alloc] initWithFrame:CGRectMake(0, 0, Window_Width, 60) withSecion:section];
////    header.backgroundColor=RGBCOLOR(245, 245, 245);
////    header.titleLabel.text = [_sectionCourseArray objectAtIndex:section];
////    header.titleLabel.textColor=RGBCOLOR(30, 95, 175);
////    if ( section == _selectWitch ) {
////        [header  changeArrowWithUp:NO];
////    }
////    else{
////        [header  changeArrowWithUp:YES];
////    }
////    header.courseHeadViewButtonClick = ^(NSInteger tag){
////        if ( tag == _selectWitch  ) {
////            _selectWitch = -100;
////        }else{
////            _selectWitch = tag;
////        }
////        [_courseTableView reloadData];
////    };
////    return header;
//    
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
