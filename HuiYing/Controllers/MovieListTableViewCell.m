//
//  MovieListTableViewCell.m
//  HuiYing
//
//  Created by Jin Xin on 15/5/16.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "MovieListTableViewCell.h"
#import "Constraits.h"

@interface MovieListTableViewCell()

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descriptionLabel;
@property (nonatomic, strong) UILabel * infoLabal;
@property (nonatomic, strong) UILabel * ratingLabel;
@property (nonatomic, strong) UIButton * buyButton;
@property (nonatomic, strong) UIImageView * versionView;

@end


@implementation MovieListTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleToFill;
        _coverImageView.opaque = YES;
        _coverImageView.frame = CGRectMake(10, 10, 65, 85);
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, 57, 200, 15);
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = UIColorFromRGB(0x6E6E6E);
        
        
        _infoLabal = [[UILabel alloc]init];
        _infoLabal.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, 78, 150, 15);
        _infoLabal.backgroundColor = [UIColor clearColor];
        _infoLabal.textAlignment = NSTextAlignmentLeft;
        _infoLabal.font = [UIFont systemFontOfSize:13];
        _infoLabal.textColor = UIColorFromRGB(0x6E6E6E);
        
        _versionView = [[UIImageView alloc]init];
        _versionView.contentMode = UIViewContentModeLeft;
        _versionView.opaque = YES;
        
        _ratingLabel = [[UILabel alloc]init];
        _ratingLabel.frame = CGRectMake(CGRectGetMaxX(_versionView.frame)+4, 20, UI_SCREEN_WIDTH-CGRectGetMaxX(_versionView.frame)-14, 20);
        _ratingLabel.backgroundColor = [UIColor clearColor];
        _ratingLabel.textAlignment = NSTextAlignmentRight;
        _ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18];
        _ratingLabel.textColor = UIColorFromRGB(0xFF7833);
        
        UIImage * buttonImage = [UIImage imageNamed:@"list_movie_btn_buy"];
        _buyButton = [[UIButton alloc]init];
        _buyButton.frame = CGRectMake(UI_SCREEN_WIDTH - 10 - buttonImage.size.width, 56, buttonImage.size.width, buttonImage.size.height);
        [_buyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        NSAttributedString* title = [[NSAttributedString alloc]initWithString:@"购票" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0xFE6F80)}];
        [_buyButton setAttributedTitle:title forState:UIControlStateNormal];
        
        [self addSubview:_coverImageView];
        [self addSubview:_titleLabel];
        [self addSubview:_versionView];
        [self addSubview:_descriptionLabel];
        [self addSubview:_infoLabal];
        [self addSubview:_ratingLabel];
        [self addSubview:_buyButton];
    }
    return self;
}

-(void)showMovieCell{
    _coverImageView.image = [UIImage imageNamed:@"image"];
    _titleLabel.text = _movieMeta.chineseName;
//    CGFloat titleWidth = [_titleLabel.text sizeWithFont:_titleLabel.font].width;
    CGFloat titleWidth = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].width;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame)+10, 20, titleWidth, 20);
    _versionView.frame= CGRectMake(CGRectGetMaxX(_titleLabel.frame)+4, 20, 50, 20);
    _versionView.image =[self versionImage];
    _descriptionLabel.text = _movieMeta.subtitle;
    _infoLabal.text = [NSString stringWithFormat:@"今天%d家影院%d场",67,956];
    _ratingLabel.text =[NSString stringWithFormat:@"%.1f", (float)_movieMeta.rate/10];
}

-(UIImage*)versionImage{
    UIImage* image = nil;
    switch (_movieMeta.version) {
        case kMovieVersion2DIMAX:
            image = [UIImage imageNamed:@"list_movie_ico_imax2d"];
            break;
        case kMovieVersion3D:
            image = [UIImage imageNamed:@"list_movie_ico_3d"];
            break;
        case kMovieVersion3DIMAX:
            image = [UIImage imageNamed:@"list_movie_ico_imax3d"];
            break;
        default:
            break;
    }
    return image;
}

@end
