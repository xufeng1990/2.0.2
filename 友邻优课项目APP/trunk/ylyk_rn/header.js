_fetchListData() {
if (pageNum > 1) {
    this.setState({
        loaded: true
    });
}
// fetch(requestURL, {
//     method: 'get',
//     headers: headerObj,
// }).then(response =>{
//   if (response.ok) {
//       return response.json();
//   } else {
//       this.setState({error:true,loaded:true});
//   }
}).then(json => {
    // let responseCode = json.code;
    // if (responseCode == 0) {
    //     let responseData = json.data;

    pageCount = responseData.count;
    let list = responseData.data;

    if (orderList == null) {
        orderList = [];
        currentCount = 0;
    } else {
        currentCount = list.length;
    }
    if (currentCount < pageSize) {
        //当当前返回的数据小于PageSize时，认为已加载完毕
        this.setState({
            foot: 1,
            moreText: moreText
        });
    } else { //设置foot 隐藏Footer
        this.setState({
            foot: 0
        });
    }
    for (var i = 0; i < list.length; i++) {
        totalList.push(list[i]);
    }

    this.setState({
        dataSource: this.state.dataSource.cloneWithRows(totalList),
        loaded: true,
    });
} else {
    this.setState({
        error: true,
        loaded: true
    });
}
}).catch(function(error) {
    this.setState({
        error: true,
        loaded: true
    });
});
}