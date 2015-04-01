# dpd-count

Deployd plugin that makes it easy to count documents.

**Warning!** This plugin adds an 'ON COUNT' event to all collections! Make sure to restrict access there!

## Why

Deployd is built so that only 'root' can count documents. But sometimes it can be useful to count documents that match a query from frontend, too.

## Usage

```
dpd.mycollection.get({id: "count"}, function(res) {
    console.log(res) // res === {"count": 10200}
})
```