# Habitat package: pd-server

## Description

[PD](https://github.com/pingcap/pd) is the Consul of [TiDB](https://github.com/pingcap/tidb) (which is really just [etcd](https://github.com/coreos/etcd) under the covers with some fliar).

This package attempts to automate the running of a PD Cluster.

## Usage

```
hab studio enter
hab pkg export docker qubitrenegade/pd
# run this x3
docker run qubitrenegade/pd --peer 172.17.0.2 --peer 172.17.0.3 --peer 172.17.0.4 --topology leader
```

Not sure if it's actually running or not...

The initial cluster should only be build once Habitat has a quorum.   (thought it seems you can start in solo mode?).  It's setup to broadcast {{sys.ip}} for cluster communications.  

This bit:

```
initial-cluster = """
{{#eachAlive svc.members as |member| ~}}
  {{member.sys.hostname}}=http://{{member.sys.ip}}:2380{{~#unless @last}},{{/unless}}
{{/eachAlive ~}}
"""
```

Searches for each member of the svc group, and builds a string, e.g.:

```
initial-cluster = """
  foo=http://172.17.0.2:2380,
  bar=http://172.17.0.3:2380,
  baz=http://172.17.0.3:2380
"""
```

PD seems to be upset about something to do with Jenkins:

```
pd.default(E): main.go:92: [fatal] run server failed: /home/jenkins/workspace/build_pd_master/go/src/github.com/pingcap/pd/server/server.go:161: receive signal terminated when waiting embed etcd to be ready
pd.default(E): /home/jenkins/workspace/build_pd_master/go/src/github.com/pingcap/pd/server/server.go:285```

Welcome any feedback...
