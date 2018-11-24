//
//  QUestionsViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "QUestionsViewController.h"
#import "QustionsCell.h"
#import "QuestsModel.h"
#import "PageQueryModel.h"
@interface QUestionsViewController ()
@property (nonatomic ,strong) QuestsModel *questsModel;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) NSMutableArray *middleArr;
@property (nonatomic, strong) PageQueryModel *pageQueryModel;
@end

@implementation QUestionsViewController
{
    NSMutableArray *indexPaths;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    indexPaths = [NSMutableArray array];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self prepareDataWithCount:0];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.questsModel = [QuestsModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    if (self.questsModel.isExpand == YES){
        if ([indexPaths containsObject:indexPath]) {
            NSString *textStr = self.dataSourceArr[indexPath.row][@"answer"];
            /*!< 计算正文高度 >*/
            NSMutableAttributedString * artical_main_text = [[NSMutableAttributedString alloc] initWithData:[textStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            CGSize artical_main_text_size = [artical_main_text boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(16)*2, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            CGFloat f = artical_main_text_size.height + 72 ;
            return f;
        }
    }else{
        if ([indexPaths containsObject:indexPath]) {
            NSString *textStr = self.dataSourceArr[indexPath.row][@"answer"];
            /*!< 计算正文高度 >*/
            NSMutableAttributedString * artical_main_text = [[NSMutableAttributedString alloc] initWithData:[textStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            CGSize artical_main_text_size = [artical_main_text boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(16)*2, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            CGFloat f = artical_main_text_size.height + 72 ;
            return f;
        }
    }
    return 62;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString * stringID = [NSString stringWithFormat:@"QustionsCell%ld",(long)indexPath.row];
    QustionsCell *cell = [tableView dequeueReusableCellWithIdentifier:stringID];
    if (!cell) {
        cell = [[QustionsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringID];
    }
    cell.model = self.middleArr[indexPath.row];
    cell.tipButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if ([indexPaths containsObject:indexPath]) {
        [indexPaths removeObject:indexPath];
        for (int i = 0; i < self.dataSourceArr.count; i ++) {
            if (i == indexPath.row) {
                self.questsModel = self.middleArr[i];
                self.questsModel.isExpand = NO;
            }
        }
    }else{
        [indexPaths addObject:indexPath];
        for (int i = 0; i < self.dataSourceArr.count; i ++) {
            if (i == indexPath.row) {
                self.questsModel = self.middleArr[i];
                self.questsModel.isExpand = YES;
            }
        }
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setRequestParams{
    self.cmd = XQuestionInfo;
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[self.pageQueryModel mj_keyValues],@"pageQueryReq", nil];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = [NSMutableArray arrayWithObject:response.data[@"dataRows"]][0];
    [self.dataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.questsModel = [QuestsModel mj_objectWithKeyValues:obj];
        [self.middleArr addObject:self.questsModel];
    }];
    [self.tableView reloadData];
}
- (QuestsModel *)questsModel{
    if (!_questsModel) {
        _questsModel = [[QuestsModel alloc]init];
    }
    return _questsModel;
}
-(NSMutableArray *)middleArr{
    if (!_middleArr) {
        _middleArr = [NSMutableArray array];
    }
    return _middleArr;
}
- (PageQueryModel *)pageQueryModel{
    if (!_pageQueryModel) {
        _pageQueryModel = [[PageQueryModel alloc]init];
    }
    return _pageQueryModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
