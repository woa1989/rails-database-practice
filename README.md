# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

文章内容包括：

* 基础 model: user post comment tag
* n+1, lazy loading, eager loading
* join
* 事物，锁
* 经验总结，陷阱，最佳实践，Deco拆分
  * 数据删除时 注意多删除，关联关系，级联删除
  * 查询是只使用自己要使用的字段
  * 分页查询时，注意性能问题
* 属性验证，错误信息，回调相关
