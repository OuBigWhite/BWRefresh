# BWRefresh
简易的下拉刷新上拉加载

## 使用
```swift
tableView.bw_header = BWRefreshHeader(action: {
  // 下拉刷新
})

tableView.bw_footer = BWRefreshFooter(action: {
  // 上拉加载
})

// 结束刷新/加载动画
tableView.bw_footer.endRefresh()
tableView.bw_header.endRefresh()

```

## 自定义
新建footer类或header类并遵循BWRefreshHeaderProtocol或BWRefreshFooterProtocol协议就行了
