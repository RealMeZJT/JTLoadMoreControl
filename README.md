UITableView上拉加载更多的控件。

![loadMoreNormal](http://7xr5jb.com1.z0.glb.clouddn.com/readme%23loadMoreNormal.png)
![loadMoreFaild](http://7xr5jb.com1.z0.glb.clouddn.com/readme%23loadMoreFaild.png)
![loadMoreNoMoreData](http://7xr5jb.com1.z0.glb.clouddn.com/readme%23loadMoreNoMoreData.png)

# 安装
## Carthage
确保你的计算机安装 [Carthage](https://github.com/Carthage/Carthage) 了。在项目根目录下创建 `Cartfile` 文件并写入：

```bash
github "RealMeZJT/JTLoadMoreControl"
```

并使用 Terminal 在项目根目录下执行：

```bash
$ carthage update
```

## 手动

1. 下载 JTLoadMoreControl 仓库
2. 将名为 JTLoadMoreControl 的子目录拷贝到你的项目中

# 基本用法
创建一个 JTLoadMoreControl 对象：

```swift
var loadMoreControl = JTLoadMoreControl()
```
将 JTLoadMoreControl 作为 tableView 的 footer：

```swift
tableView.tableFooterView = loadMoreControl
```


当用户滑动到底部时，就会触发上拉刷新事件。监听并处理上拉刷新事件：

```swift
override func viewDidLoad() {
	loadMoreControl.addTarget(self, action: #selector(loadingMore), for: .valueChanged)
}
func loadingMore() {
    //在这里请求获取下一页
}
```

加载完成后，关闭加载动画：

```swift
loadMoreControl.endLoading()
```
加载失败后，停止加载动画，并且提示用户点击重试：

```swift
loadMoreControl.endLoadingDueToFailed()
```
没有更多数据时：

```swift
loadMoreControl.endLoadingDueToNoMoreData()
```
