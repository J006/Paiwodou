# Paiwodou
拍我网旗下iOS产品Po  

之前已经解散的公司的一个未上线iOS产品,也算是本人第一个iOS互联网产品,从登录前段到主界面展示到后台的网络请求端都是个人独立完成.  

虽然耗时较长,但也算一个成熟的社交类图文产品.  

由于服务器端已经过期,所以无法提供相应的请求返回,因此无法通过模拟器打开测试,所以只能看看架构和代码.代码架构参考Coding,也使用里面部分开源的category.提供pod文件,需要的人可以通过pod自行导入相应的开源框架.  

代码整体架构介绍如下:  
  
该项目主要通过各个界面来进行区分,所有后台连接类代码放在一个统一的文件中供调用,下面会提到.  

1.RecommendPhotographer  
推荐的摄影师展示界面  
  
2.NotificationView  
该文件夹主要包括一个自定义的自动下滑提醒页面,用在登录界面的输入账号名和密码进行出错判断时给予用户的信息提示  
  
3.ShareView
由于本产品并没有使用流行的ShareSDK来做第三方登录和分享界面,因此这个文件夹就是来提供一个类似ShareSDK的自定义分享,可分享的接口目前是微信,微信朋友圈,微博,QQ等,你也可以自己对他进行添加.  

4.RecommendView  
用户第一次登录时给他的推荐,尚未完成  

5.FollowAndFans  
粉丝和关注的人员界面  

6.LoginAndRegister  
登录和注册界面,其中包括开头的展示动画,注册,登录,忘记密码等等界面,包括第三方登录.  

7.UIMessageInputView  
从Coding那里借鉴过来的输入框,用以评论界面.  

8.Profiel  
个人主页界面,包括各种背景和头像展示,可上划展示自己的界面首页;同样,该界面也是浏览其他摄影师时展示界面  

9.Setting  
个人设置界面:包括个人信息,签名,头像,地址等等.  

10.MainPage  
登录后的展示界面,主要通过上下2个ScrollView来实现,下面的ScrollView为一个图文展示;其实该界面应该使用UICollectionviews最为好,当时不熟.通过.m文件中导入的文件和对象就可以看出,PocketAndPhotoView这个view为主要展示的内容页,MainBanner为顶部展示的流动页面,MiddleBanner为中间界面展示. 

11.DetailPage  
该文件夹包括了每一张照片点击后展示的照片专辑详细界面展示AlbumDetailPage  
包括了PocketAndPhotoView和AlbumDetailPage都需要用到的一个图片排列view:PhotoImageWallView  
包括了一个图片html5界面展示的vc:PocketDetailHTML  
最后包括了一个所有详细界面底部栏PocketLikeCommentToolBar  

12.PocketPhotos  
10里已经提到的内容界面,他包括3大类型的界面展示,在初始化时分别通过不同的model来进行赋值并展现出来.  
3个形式就是:Pocket,Album,RecommendPhoto  

13.ImageDetailView  
该文件夹包括点击专辑界面Album或者单张RecommendPhoto时跳转到的一个展示界面TotalPhotoViewController,该界面拥有分享功能其中还带一个评论界面CommentViewController.   
ImageDetailView为一个单张图片点击后大图的展示,提供放大缩小和收藏等功能  

14.MainBanner  
10中提到的顶部Banner界面  

15.Vendor  
一些model和category (我知道这个文件夹名字不对,也比较乱)  

16.Search  
搜索的主界面,UITableView展示,各种单个的cell编写.  
标签形式的搜索关键字展示,使用一个自定义的CustomSearchBar来覆盖在搜索好的默认搜索框上来展示.  

17.MiddleBanner  
10中提到的中间的Banner的展示界面  

18.Information  
个人消息界面,提供消息的发送和接受,尚未完成  

19.ThriftFrameWork  
由于后台使用了Thrift框架,这是基于iOS的一些类,用以后台连接使用  

20.About  
关于界面  

21.Model  
部分model  

22.RootViewController  
BaseViewController为基础的VC类,所有VC都继承他,从而能统一管理相关Push和Pop动画.  
RootTabViewController主界面的tab型toolbar,使用一个RDVTabBarController的开源框架  

23.PaiWoAPI  
DouAPIManager为主后台的所有连接接口类  

24.Util  
包括了部分category,分享类工具类,用户地址获取等等工具类,以及一些自定义的控件  

25.DouPaiwo  
主程序类  
