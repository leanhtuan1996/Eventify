//
//  ZSSColorViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/12/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSColorViewController.h"

@interface ZSSColorViewController ()

@end

@implementation ZSSColorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Chi tiết sự kiện";
    
    // Set the toolbar item color
    self.toolbarItemTintColor = [UIColor blackColor];
    
    // Set the toolbar selected color
    self.toolbarItemSelectedTintColor = [UIColor brownColor];
    
    //self.enabledToolbarItems = @[ZSSRichTextEditorToolbarBold, ZSSRichTextEditorToolbarH1, ZSSRichTextEditorToolbarParagraph];
    
    // Set the HTML contents of the editor
    //[self setHTML:html];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
