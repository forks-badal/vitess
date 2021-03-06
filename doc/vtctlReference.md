This reference guide explains the commands that the <b>vtctl</b> tool supports. **vtctl** is a command-line tool used to administer a Vitess cluster, and it allows a human or application to easily interact with a Vitess implementation.

Commands are listed in the following groups:

* [Generic](#generic)
* [Keyspaces](#keyspaces)
* [Replication Graph](#replication-graph)
* [Schema, Version, Permissions](#schema,-version,-permissions)
* [Serving Graph](#serving-graph)
* [Shards](#shards)
* [Tablets](#tablets)


## Generic

* [ListAllTablets](#listalltablets)
* [ListTablets](#listtablets)
* [Resolve](#resolve)
* [Validate](#validate)

### ListAllTablets

Lists all tablets in an awk-friendly way.

#### Example

<pre class="command-example">ListAllTablets &lt;cell name&gt;</pre>

#### Arguments

* <code>&lt;cell name&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 

#### Errors

* The <code>&lt;cell name&gt;</code> argument is required for the <code>&lt;ListAllTablets&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ListTablets

Lists specified tablets in an awk-friendly way.

#### Example

<pre class="command-example">ListTablets &lt;tablet alias&gt; ...</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>.  To specify multiple values for this argument, separate individual values with a space.

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;ListTablets&gt;</code> command. This error occurs if the command is not called with at least one argument.


### Resolve

Reads a list of addresses that can answer this query. The port name can be mysql, vt, or vts. Vitess uses this name to retrieve the actual port number from the topology server (ZooKeeper or etcd).

#### Example

<pre class="command-example">Resolve &lt;keyspace&gt;.&lt;shard&gt;.&lt;db type&gt;:&lt;port name&gt;</pre>

#### Arguments

* <code>&lt;keyspace&gt;</code>.<code>&lt;shard&gt;</code>.<code>&lt;db type&gt;</code>:<code>&lt;port name&gt;</code> &ndash; Required.

#### Errors

* The <code>&lt;Resolve&gt;</code> command requires a single argument, the value of which must be in the format <code>&lt;keyspace&gt;</code>.<code>&lt;shard&gt;</code>.<code>&lt;db type&gt;</code>:<code>&lt;port name&gt;</code>. This error occurs if the command is not called with exactly one argument.


### Validate

Validates that all nodes reachable from the global replication graph and that all tablets in all discoverable cells are consistent.

#### Example

<pre class="command-example">Validate [-ping-tablets]</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| ping-tablets | Boolean | Indicates whether all tablets should be pinged during the validation process |




## Keyspaces

* [CreateKeyspace](#createkeyspace)
* [FindAllShardsInKeyspace](#findallshardsinkeyspace)
* [GetKeyspace](#getkeyspace)
* [MigrateServedFrom](#migrateservedfrom)
* [MigrateServedTypes](#migrateservedtypes)
* [RebuildKeyspaceGraph](#rebuildkeyspacegraph)
* [SetKeyspaceServedFrom](#setkeyspaceservedfrom)
* [SetKeyspaceShardingInfo](#setkeyspaceshardinginfo)
* [ValidateKeyspace](#validatekeyspace)

### CreateKeyspace

Creates the specified keyspace.

#### Example

<pre class="command-example">CreateKeyspace [-sharding_column_name=name] [-sharding_column_type=type] [-served_from=tablettype1:ks1,tablettype2,ks2,...] [-split_shard_count=N] [-force] &lt;keyspace name&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Proceeds even if the keyspace already exists |
| served_from | string | Specifies a comma-separated list of dbtype:keyspace pairs used to serve traffic |
| sharding_column_name | string | Specifies the column to use for sharding operations |
| sharding_column_type | string | Specifies the type of the column to use for sharding operations |
| split_shard_count | Int | Specifies the number of shards to use for data splits |


#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;CreateKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.
* The <code>&lt;sharding_column_type&gt;</code> flag specifies an invalid value.
* The <code>&lt;served_from&gt;</code> flag specifies a database (tablet) type that is not in the serving graph. The invalid value is: %v


### FindAllShardsInKeyspace

Displays all of the shards in the specified keyspace.

#### Example

<pre class="command-example">FindAllShardsInKeyspace &lt;keyspace&gt;</pre>

#### Arguments

* <code>&lt;keyspace&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace&gt;</code> argument is required for the <code>&lt;FindAllShardsInKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### GetKeyspace

Outputs a JSON structure that contains information about the Keyspace.

#### Example

<pre class="command-example">GetKeyspace &lt;keyspace&gt;</pre>

#### Arguments

* <code>&lt;keyspace&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace&gt;</code> argument is required for the <code>&lt;GetKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### MigrateServedFrom

Makes the &lt;destination keyspace/shard&gt; serve the given type. This command also rebuilds the serving graph.

#### Example

<pre class="command-example">MigrateServedFrom [-cells=c1,c2,...] [-reverse] &lt;destination keyspace/shard&gt; &lt;served tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |
| filtered_replication_wait_time | Duration | Specifies the maximum time to wait, in seconds, for filtered replication to catch up on master migrations |
| reverse | Boolean | Moves the served tablet type backward instead of forward. Use in case of trouble |


#### Arguments

* <code>&lt;destination keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;served tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;destination keyspace/shard&gt;</code> and <code>&lt;served tablet type&gt;</code> arguments are both required for the <code>&lt;MigrateServedFrom&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### MigrateServedTypes

Migrates a serving type from the source shard to the shards that it replicates to. This command also rebuilds the serving graph. The &lt;keyspace/shard&gt; argument can specify any of the shards involved in the migration.

#### Example

<pre class="command-example">MigrateServedTypes [-cells=c1,c2,...] [-reverse] [-skip-refresh-state] &lt;keyspace/shard&gt; &lt;served tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |
| filtered_replication_wait_time | Duration | Specifies the maximum time to wait, in seconds, for filtered replication to catch up on master migrations |
| reverse | Boolean | Moves the served tablet type backward instead of forward. Use in case of trouble |
| skip-refresh-state | Boolean | Skips refreshing the state of the source tablets after the migration, meaning that the refresh will need to be done manually, replica and rdonly only) |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;served tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;source keyspace/shard&gt;</code> and <code>&lt;served tablet type&gt;</code> arguments are both required for the <code>&lt;MigrateServedTypes&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.
* The <code>&lt;skip-refresh-state&gt;</code> flag can only be specified for non-master migrations.


### RebuildKeyspaceGraph

Rebuilds the serving data for the keyspace and, optionally, all shards in the specified keyspace. This command may trigger an update to all connected clients.

#### Example

<pre class="command-example">RebuildKeyspaceGraph [-cells=a,b] [-rebuild_srv_shards] &lt;keyspace&gt; ...</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |
| rebuild_srv_shards | Boolean | Indicates whether all SrvShard objects should also be rebuilt. The default value is <code>false</code>. |


#### Arguments

* <code>&lt;keyspace&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace.  To specify multiple values for this argument, separate individual values with a space.

#### Errors

* The <code>&lt;keyspace&gt;</code> argument must be used to specify at least one keyspace when calling the <code>&lt;RebuildKeyspaceGraph&gt;</code> command. This error occurs if the command is not called with at least one argument.


### SetKeyspaceServedFrom

Changes the ServedFromMap manually. This command is intended for emergency fixes. This field is automatically set when you call the *MigrateServedFrom* command. This command does not rebuild the serving graph.

#### Example

<pre class="command-example">SetKeyspaceServedFrom [-source=&lt;source keyspace name&gt;] [-remove] [-cells=c1,c2,...] &lt;keyspace name&gt; &lt;tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to affect |
| remove | Boolean | Indicates whether to add (default) or remove the served from record |
| source | string | Specifies the source keyspace name |


#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 
* <code>&lt;tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;keyspace name&gt;</code> and <code>&lt;tablet type&gt;</code> arguments are required for the <code>&lt;SetKeyspaceServedFrom&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### SetKeyspaceShardingInfo

Updates the sharding information for a keyspace.

#### Example

<pre class="command-example">SetKeyspaceShardingInfo [-force] [-split_shard_count=N] &lt;keyspace name&gt; [&lt;column name&gt;] [&lt;column type&gt;]</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Updates fields even if they are already set. Use caution before calling this command. |
| split_shard_count | Int | Specifies the number of shards to use for data splits |


#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 
* <code>&lt;column name&gt;</code> &ndash; Optional.
* <code>&lt;column type&gt;</code> &ndash; Optional.

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;SetKeyspaceShardingInfo&gt;</code> command. The <code>&lt;column name&gt;</code> and <code>&lt;column type&gt;</code> arguments are both optional. This error occurs if the command is not called with between 1 and 3 arguments.
* The <code>&lt;column type&gt;</code> argument specifies an invalid value for the sharding_column_type.


### ValidateKeyspace

Validates that all nodes reachable from the specified keyspace are consistent.

#### Example

<pre class="command-example">ValidateKeyspace [-ping-tablets] &lt;keyspace name&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| ping-tablets | Boolean | Specifies whether all tablets will be pinged during the validation process |


#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;ValidateKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


## Replication Graph

* [GetShardReplication](#getshardreplication)

### GetShardReplication

Outputs a JSON structure that contains information about the ShardReplication.

#### Example

<pre class="command-example">GetShardReplication &lt;cell&gt; &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 
* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;cell&gt;</code> and <code>&lt;keyspace/shard&gt;</code> arguments are required for the <code>&lt;GetShardReplication&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


## Schema, Version, Permissions

* [ApplySchema](#applyschema)
* [ApplyVSchema](#applyvschema)
* [CopySchemaShard](#copyschemashard)
* [GetPermissions](#getpermissions)
* [GetSchema](#getschema)
* [GetVSchema](#getvschema)
* [ReloadSchema](#reloadschema)
* [ValidatePermissionsKeyspace](#validatepermissionskeyspace)
* [ValidatePermissionsShard](#validatepermissionsshard)
* [ValidateSchemaKeyspace](#validateschemakeyspace)
* [ValidateSchemaShard](#validateschemashard)
* [ValidateVersionKeyspace](#validateversionkeyspace)
* [ValidateVersionShard](#validateversionshard)

### ApplySchema

Applies the schema change to the specified keyspace on every master, running in parallel on all shards. The changes are then propagated to slaves via replication. If the force flag is set, then numerous checks will be ignored, so that option should be used very cautiously.

#### Example

<pre class="command-example">ApplySchema [-force] {-sql=&lt;sql&gt; || -sql-file=&lt;filename&gt;} &lt;keyspace&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Applies the schema even if the preflight schema doesn't match |
| sql | string | A list of semicolon-delimited SQL commands |
| sql-file | string | Identifies the file that contains the SQL commands |
| wait_slave_timeout | Duration | The amount of time to wait for slaves to catch up during reparenting. The default value is 30 seconds. |


#### Arguments

* <code>&lt;keyspace&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace&gt;</code> argument is required for the command<code>&lt;ApplySchema&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ApplyVSchema

Applies the VTGate routing schema.

#### Example

<pre class="command-example">ApplyVSchema {-vschema=&lt;vschema&gt; || -vschema_file=&lt;vschema file&gt;}</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| vschema | string | Identifies the VTGate routing schema |
| vschema_file | string | Identifies the VTGate routing schema file |


#### Errors

* Either the <code>&lt;vschema&gt;</code> or <code>&lt;vschema&gt;</code>File flag must be specified when calling the <code>&lt;ApplyVSchema&gt;</code> command.
* %T does not support <code>&lt;vschema&gt;</code> operations


### CopySchemaShard

Copies the schema from a source tablet to the specified shard. The schema is applied directly on the master of the destination shard, and it is propagated to the replicas through binlogs.

#### Example

<pre class="command-example">CopySchemaShard [-tables=&lt;table1&gt;,&lt;table2&gt;,...] [-exclude_tables=&lt;table1&gt;,&lt;table2&gt;,...] [-include-views] &lt;source tablet alias&gt; &lt;destination keyspace/shard&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| exclude_tables | string | Specifies a comma-separated list of regular expressions for which tables to exclude |
| include-views | Boolean | Includes views in the output |
| tables | string | Specifies a comma-separated list of regular expressions for which tables  gather schema information for |


#### Arguments

* <code>&lt;source tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;destination keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;keyspace/shard&gt;</code> arguments are both required for the <code>&lt;CopySchemaShard&gt;</code> command. The <code>&lt;tablet alias&gt;</code> argument identifies a source and the <code>&lt;keyspace/shard&gt;</code> argument identifies a destination. This error occurs if the command is not called with exactly 2 arguments.


### GetPermissions

Displays the permissions for a tablet.

#### Example

<pre class="command-example">GetPermissions &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;GetPermissions&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### GetSchema

Displays the full schema for a tablet, or just the schema for the specified tables in that tablet.

#### Example

<pre class="command-example">GetSchema [-tables=&lt;table1&gt;,&lt;table2&gt;,...] [-exclude_tables=&lt;table1&gt;,&lt;table2&gt;,...] [-include-views] &lt;tablet alias&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| exclude_tables | string | Specifies a comma-separated list of regular expressions for tables to exclude |
| include-views | Boolean | Includes views in the output |
| table_names_only | Boolean | Only displays table names that match |
| tables | string | Specifies a comma-separated list of regular expressions for which tables should gather information |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;GetSchema&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### GetVSchema

Displays the VTGate routing schema.

#### Errors

* The <code>&lt;GetVSchema&gt;</code> command does not support any arguments. This error occurs if the command is not called with exactly 0 arguments.
* %T does not support the vschema operations


### ReloadSchema

Reloads the schema on a remote tablet.

#### Example

<pre class="command-example">ReloadSchema &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;ReloadSchema&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidatePermissionsKeyspace

Validates that the master permissions from shard 0 match those of all of the other tablets in the keyspace.

#### Example

<pre class="command-example">ValidatePermissionsKeyspace &lt;keyspace name&gt;</pre>

#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;ValidatePermissionsKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidatePermissionsShard

Validates that the master permissions match all the slaves.

#### Example

<pre class="command-example">ValidatePermissionsShard &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;ValidatePermissionsShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidateSchemaKeyspace

Validates that the master schema from shard 0 matches the schema on all of the other tablets in the keyspace.

#### Example

<pre class="command-example">ValidateSchemaKeyspace [-exclude_tables=''] [-include-views] &lt;keyspace name&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| exclude_tables | string | Specifies a comma-separated list of regular expressions for tables to exclude |
| include-views | Boolean | Includes views in the validation |


#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;ValidateSchemaKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidateSchemaShard

Validates that the master schema matches all of the slaves.

#### Example

<pre class="command-example">ValidateSchemaShard [-exclude_tables=''] [-include-views] &lt;keyspace/shard&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| exclude_tables | string | Specifies a comma-separated list of regular expressions for tables to exclude |
| include-views | Boolean | Includes views in the validation |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;ValidateSchemaShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidateVersionKeyspace

Validates that the master version from shard 0 matches all of the other tablets in the keyspace.

#### Example

<pre class="command-example">ValidateVersionKeyspace &lt;keyspace name&gt;</pre>

#### Arguments

* <code>&lt;keyspace name&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace name&gt;</code> argument is required for the <code>&lt;ValidateVersionKeyspace&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidateVersionShard

Validates that the master version matches all of the slaves.

#### Example

<pre class="command-example">ValidateVersionShard &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is requird for the <code>&lt;ValidateVersionShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


## Serving Graph

* [GetEndPoints](#getendpoints)
* [GetSrvKeyspace](#getsrvkeyspace)
* [GetSrvKeyspaceNames](#getsrvkeyspacenames)
* [GetSrvShard](#getsrvshard)

### GetEndPoints

Outputs a JSON structure that contains information about the EndPoints.

#### Example

<pre class="command-example">GetEndPoints &lt;cell&gt; &lt;keyspace/shard&gt; &lt;tablet type&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 
* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;cell&gt;</code>, <code>&lt;keyspace/shard&gt;</code>, and <code>&lt;tablet type&gt;</code> arguments are required for the <code>&lt;GetEndPoints&gt;</code> command. This error occurs if the command is not called with exactly 3 arguments.


### GetSrvKeyspace

Outputs a JSON structure that contains information about the SrvKeyspace.

#### Example

<pre class="command-example">GetSrvKeyspace &lt;cell&gt; &lt;keyspace&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 
* <code>&lt;keyspace&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables. Vitess distributes keyspace shards into multiple machines and provides an SQL interface to query the data. The argument value must be a string that does not contain whitespace. 

#### Errors

* The <code>&lt;cell&gt;</code> and <code>&lt;keyspace&gt;</code> arguments are required for the <code>&lt;GetSrvKeyspace&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### GetSrvKeyspaceNames

Outputs a list of keyspace names.

#### Example

<pre class="command-example">GetSrvKeyspaceNames &lt;cell&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 

#### Errors

* The <code>&lt;cell&gt;</code> argument is required for the <code>&lt;GetSrvKeyspaceNames&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### GetSrvShard

Outputs a JSON structure that contains information about the SrvShard.

#### Example

<pre class="command-example">GetSrvShard &lt;cell&gt; &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 
* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;cell&gt;</code> and <code>&lt;keyspace/shard&gt;</code> arguments are required for the <code>&lt;GetSrvShard&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


## Shards

* [CreateShard](#createshard)
* [DeleteShard](#deleteshard)
* [GetShard](#getshard)
* [ListShardTablets](#listshardtablets)
* [RebuildShardGraph](#rebuildshardgraph)
* [RemoveShardCell](#removeshardcell)
* [SetShardServedTypes](#setshardservedtypes)
* [SetShardTabletControl](#setshardtabletcontrol)
* [ShardReplicationFix](#shardreplicationfix)
* [ShardReplicationPositions](#shardreplicationpositions)
* [SourceShardAdd](#sourceshardadd)
* [SourceShardDelete](#sourcesharddelete)
* [TabletExternallyReparented](#tabletexternallyreparented)
* [ValidateShard](#validateshard)

### CreateShard

Creates the specified shard.

#### Example

<pre class="command-example">CreateShard [-force] [-parent] &lt;keyspace/shard&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Proceeds with the command even if the keyspace already exists |
| parent | Boolean | Creates the parent keyspace if it doesn't already exist |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;CreateShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### DeleteShard

Deletes the specified shard(s).

#### Example

<pre class="command-example">DeleteShard &lt;keyspace/shard&gt; ...</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>.  To specify multiple values for this argument, separate individual values with a space.

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument must be used to identify at least one keyspace and shard when calling the <code>&lt;DeleteShard&gt;</code> command. This error occurs if the command is not called with at least one argument.


### GetShard

Outputs a JSON structure that contains information about the Shard.

#### Example

<pre class="command-example">GetShard &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;GetShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ListShardTablets

Lists all tablets in the specified shard.

#### Example

<pre class="command-example">ListShardTablets &lt;keyspace/shard&gt;)</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;ListShardTablets&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### RebuildShardGraph

Rebuilds the replication graph and shard serving data in ZooKeeper or etcd. This may trigger an update to all connected clients.

#### Example

<pre class="command-example">RebuildShardGraph [-cells=a,b] &lt;keyspace/shard&gt; ...</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>.  To specify multiple values for this argument, separate individual values with a space.

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument must be used to identify at least one keyspace and shard when calling the <code>&lt;RebuildShardGraph&gt;</code> command. This error occurs if the command is not called with at least one argument.


### RemoveShardCell

Removes the cell from the shard's Cells list.

#### Example

<pre class="command-example">RemoveShardCell [-force] &lt;keyspace/shard&gt; &lt;cell&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Proceeds even if the cell's topology server cannot be reached to check for tablets |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> and <code>&lt;cell&gt;</code> arguments are required for the <code>&lt;RemoveShardCell&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### SetShardServedTypes

Sets a given shard's served tablet types. Does not rebuild any serving graph.

#### Example

<pre class="command-example">SetShardServedTypes &lt;keyspace/shard&gt; [&lt;served tablet type1&gt;,&lt;served tablet type2&gt;,...]</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |
| remove | Boolean | Removes the served tablet type |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;served tablet type&gt;</code> &ndash; Optional. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;keyspace/shard&gt;</code> and <code>&lt;served tablet type&gt;</code> arguments are both required for the <code>&lt;SetShardServedTypes&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### SetShardTabletControl

Sets the TabletControl record for a shard and type. Only use this for an emergency fix or after a finished vertical split. The *MigrateServedFrom* and *MigrateServedType* commands set this field appropriately already. Always specify the blacklisted_tables flag for vertical splits, but never for horizontal splits.

#### Example

<pre class="command-example">SetShardTabletControl [--cells=c1,c2,...] [--blacklisted_tables=t1,t2,...] [--remove] [--disable_query_service] &lt;keyspace/shard&gt; &lt;tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| cells | string | Specifies a comma-separated list of cells to update |
| disable_query_service | Boolean | Disables query service on the provided nodes |
| remove | Boolean | Removes cells for vertical splits. This flag requires the *tables* flag to also be set. |
| tables | string | Specifies a comma-separated list of tables to replicate (used for vertical split) |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;keyspace/shard&gt;</code> and <code>&lt;tablet type&gt;</code> arguments are both required for the <code>&lt;SetShardTabletControl&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### ShardReplicationFix

Walks through a ShardReplication object and fixes the first error that it encounters.

#### Example

<pre class="command-example">ShardReplicationFix &lt;cell&gt; &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;cell&gt;</code> &ndash; Required. A cell is a location for a service. Generally, a cell resides in only one cluster. In Vitess, the terms "cell" and "data center" are interchangeable. The argument value is a string that does not contain whitespace. 
* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;cell&gt;</code> and <code>&lt;keyspace/shard&gt;</code> arguments are required for the ShardReplicationRemove command. This error occurs if the command is not called with exactly 2 arguments.


### ShardReplicationPositions

Shows the replication status of each slave machine in the shard graph. In this case, the status refers to the replication lag between the master vttablet and the slave vttablet. In Vitess, data is always written to the master vttablet first and then replicated to all slave vttablets.

#### Example

<pre class="command-example">ShardReplicationPositions &lt;keyspace/shard&gt;</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;ShardReplicationPositions&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### SourceShardAdd

Adds the SourceShard record with the provided index. This is meant as an emergency function. It does not call RefreshState for the shard master.

#### Example

<pre class="command-example">SourceShardAdd [--key_range=&lt;keyrange&gt;] [--tables=&lt;table1,table2,...&gt;] &lt;keyspace/shard&gt; &lt;uid&gt; &lt;source keyspace/shard&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| key_range | string | Identifies the key range to use for the SourceShard |
| tables | string | Specifies a comma-separated list of tables to replicate (used for vertical split) |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;uid&gt;</code> &ndash; Required.
* <code>&lt;source keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code>, <code>&lt;uid&gt;</code>, and <code>&lt;source keyspace/shard&gt;</code> arguments are all required for the <code>&lt;SourceShardAdd&gt;</code> command. This error occurs if the command is not called with exactly 3 arguments.


### SourceShardDelete

Deletes the SourceShard record with the provided index. This is meant as an emergency cleanup function. It does not call RefreshState for the shard master.

#### Example

<pre class="command-example">SourceShardDelete &lt;keyspace/shard&gt; &lt;uid&gt;</pre>

#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 
* <code>&lt;uid&gt;</code> &ndash; Required.

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> and <code>&lt;uid&gt;</code> arguments are both required for the <code>&lt;SourceShardDelete&gt;</code> command. This error occurs if the command is not called with at least 2 arguments.


### TabletExternallyReparented

Changes metadata in the topology server to acknowledge a shard master change performed by an external tool. See the <a href=\"https://github.com/youtube/vitess/blob/master/doc/Reparenting.md#external-reparents\">Reparenting</a> guide for more information.

#### Example

<pre class="command-example">TabletExternallyReparented &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;TabletExternallyReparented&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### ValidateShard

Validates that all nodes that are reachable from this shard are consistent.

#### Example

<pre class="command-example">ValidateShard [-ping-tablets] &lt;keyspace/shard&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| ping-tablets | Boolean | Indicates whether all tablets should be pinged during the validation process |


#### Arguments

* <code>&lt;keyspace/shard&gt;</code> &ndash; Required. The name of a sharded database that contains one or more tables as well as the shard associated with the command. The keyspace must be identified by a string that does not contain whitepace, while the shard is typically identified by a string in the format <code>&lt;range start&gt;-&lt;range end&gt;</code>. 

#### Errors

* The <code>&lt;keyspace/shard&gt;</code> argument is required for the <code>&lt;ValidateShard&gt;</code> command. This error occurs if the command is not called with exactly one argument.


## Tablets

* [Backup](#backup)
* [ChangeSlaveType](#changeslavetype)
* [DeleteTablet](#deletetablet)
* [ExecuteFetchAsDba](#executefetchasdba)
* [ExecuteHook](#executehook)
* [GetTablet](#gettablet)
* [HealthStream](#healthstream)
* [InitTablet](#inittablet)
* [Ping](#ping)
* [RefreshState](#refreshstate)
* [RunHealthCheck](#runhealthcheck)
* [ScrapTablet](#scraptablet)
* [SetReadOnly](#setreadonly)
* [SetReadWrite](#setreadwrite)
* [Sleep](#sleep)
* [StartSlave](#startslave)
* [StopSlave](#stopslave)
* [UpdateTabletAddrs](#updatetabletaddrs)

### Backup

Stops mysqld and uses the BackupStorage service to store a new backup. This function also remembers if the tablet was replicating so that it can restore the same state after the backup completes.

#### Example

<pre class="command-example">Backup [-concurrency=4] &lt;tablet alias&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| concurrency | Int | Specifies the number of compression/checksum jobs to run simultaneously |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;Backup&gt;</code> command requires the <code>&lt;tablet alias&gt;</code> argument. This error occurs if the command is not called with exactly one argument.


### ChangeSlaveType

Changes the db type for the specified tablet, if possible. This command is used primarily to arrange replicas, and it will not convert a master.<br><br>NOTE: This command automatically updates the serving graph.<br><br>Valid &lt;tablet type&gt; values for this command are <code>backup</code>, <code>batch</code>, <code>experimental</code>, <code>rdonly</code>, <code>replica</code>, <code>restore</code>, <code>schema_apply</code>, <code>spare</code>, and <code>worker</code>.

#### Example

<pre class="command-example">ChangeSlaveType [-force] [-dry-run] &lt;tablet alias&gt; &lt;tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| dry-run | Boolean | Lists the proposed change without actually executing it |
| force | Boolean | Changes the slave type in ZooKeeper or etcd without running hooks |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;db type&gt;</code> arguments are required for the <code>&lt;ChangeSlaveType&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.
* failed reading tablet %v: %v
* invalid type transition %v: %v -&gt;</code> %v


### DeleteTablet

Deletes scrapped tablet(s) from the topology.

#### Example

<pre class="command-example">DeleteTablet &lt;tablet alias&gt; ...</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>.  To specify multiple values for this argument, separate individual values with a space.

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument must be used to specify at least one tablet when calling the <code>&lt;DeleteTablet&gt;</code> command. This error occurs if the command is not called with at least one argument.


### ExecuteFetchAsDba

Runs the given SQL command as a DBA on the remote tablet.

#### Example

<pre class="command-example">ExecuteFetchAsDba [--max_rows=10000] [--want_fields] [--disable_binlogs] &lt;tablet alias&gt; &lt;sql command&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| disable_binlogs | Boolean | Disables writing to binlogs during the query |
| max_rows | Int | Specifies the maximum number of rows to allow in reset |
| reload_schema | Boolean | Indicates whether the tablet schema will be reloaded after executing the SQL command. The default value is <code>false</code>, which indicates that the tablet schema will not be reloaded. |
| want_fields | Boolean | Indicates whether the request should also get field names |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;sql command&gt;</code> &ndash; Required.

#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;sql command&gt;</code> arguments are required for the <code>&lt;ExecuteFetchAsDba&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### ExecuteHook

Runs the specified hook on the given tablet. A hook is a script that resides in the $VTROOT/vthook directory. You can put any script into that directory and use this command to run that script.<br><br>For this command, the param=value arguments are parameters that the command passes to the specified hook.

#### Example

<pre class="command-example">ExecuteHook &lt;tablet alias&gt; &lt;hook name&gt; [&lt;param1=value1&gt; &lt;param2=value2&gt; ...]</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;hook name&gt;</code> &ndash; Required.
* <code>&lt;param1=value1&gt;</code> <code>&lt;param2=value2&gt;</code> . &ndash; Optional.

#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;hook name&gt;</code> arguments are required for the <code>&lt;ExecuteHook&gt;</code> command. This error occurs if the command is not called with at least 2 arguments.


### GetTablet

Outputs a JSON structure that contains information about the Tablet.

#### Example

<pre class="command-example">GetTablet &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;GetTablet&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### HealthStream

Streams the health status of a tablet.

#### Example

<pre class="command-example">HealthStream &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;HealthStream&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### InitTablet

Initializes a tablet in the topology.

#### Example

<pre class="command-example">InitTablet [-force] [-parent] [-update] [-db-name-override=&lt;db name&gt;] [-hostname=&lt;hostname&gt;] [-mysql_port=&lt;port&gt;] [-port=&lt;port&gt;] [-vts_port=&lt;port&gt;] [-keyspace=&lt;keyspace&gt;] [-shard=&lt;shard&gt;] [-parent_alias=&lt;parent alias&gt;] &lt;tablet alias&gt; &lt;tablet type&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| db-name-override | string | Overrides the name of the database that the vttablet uses |
| force | Boolean | Overwrites the node if the node already exists |
| hostname | string | The server on which the tablet is running |
| keyspace | string | The keyspace to which this tablet belongs |
| mysql_port | Int | The mysql port for the mysql daemon |
| parent | Boolean | Creates the parent shard and keyspace if they don't yet exist |
| port | Int | The main port for the vttablet process |
| shard | string | The shard to which this tablet belongs |
| tags | string | A comma-separated list of key:value pairs that are used to tag the tablet |
| update | Boolean | Performs update if a tablet with the provided alias already exists |
| vts_port | Int | The encrypted port for the vttablet process |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;tablet type&gt;</code> arguments are both required for the <code>&lt;InitTablet&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### Ping

Checks that the specified tablet is awake and responding to RPCs. This command can be blocked by other in-flight operations.

#### Example

<pre class="command-example">Ping &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;Ping&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### RefreshState

Reloads the tablet record on the specified tablet.

#### Example

<pre class="command-example">RefreshState &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;RefreshState&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### RunHealthCheck

Runs a health check on a remote tablet with the specified target type.

#### Example

<pre class="command-example">RunHealthCheck &lt;tablet alias&gt; &lt;target tablet type&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;target tablet type&gt;</code> &ndash; Required. The vttablet's role. Valid values are:

    * <code>backup</code> &ndash; A slaved copy of data that is offline to queries other than for backup purposes
    * <code>batch</code> &ndash; A slaved copy of data for OLAP load patterns (typically for MapReduce jobs)
    * <code>checker</code> &ndash; A tablet that is running a checker process. The tablet is likely lagging in replication.
    * <code>experimental</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The value indicates a special characteristic of the tablet that indicates the tablet should not be considered a potential master. Vitess also does not worry about lag for experimental tablets when reparenting.
    * <code>idle</code> &ndash; An idle vttablet that does not have a keyspace, shard or type assigned
    * <code>lag</code> &ndash; A slaved copy of data intentionally lagged for pseudo-backup.
    * <code>lag_orphan</code> &ndash; A tablet in the midst of a reparenting process. During that process, the tablet goes into a <code>lag_orphan</code> state until it is reparented properly.
    * <code>master</code> &ndash; A primary copy of data
    * <code>rdonly</code> &ndash; A slaved copy of data for OLAP load patterns
    * <code>replica</code> &ndash; A slaved copy of data ready to be promoted to master
    * <code>restore</code> &ndash; A tablet that has not been in the replication graph and is restoring from a snapshot. Typically, a tablet progresses from the <code>idle</code> state to the <code>restore</code> state and then to the <code>spare</code> state.
    * <code>schema_apply</code> &ndash; A slaved copy of data that had been serving query traffic but that is not applying a schema change. Following the change, the tablet will revert to its serving type.
    * <code>scrap</code> &ndash; A tablet that contains data that needs to be wiped.
    * <code>snapshot_source</code> &ndash; A slaved copy of data where mysqld is <b>not</b> running and where Vitess is serving data files to clone slaves. Use this command to enter this mode: <pre>vtctl Snapshot -server-mode ...</pre> Use this command to exit this mode: <pre>vtctl SnapshotSourceEnd ...</pre>
    * <code>spare</code> &ndash; A slaved copy of data that is ready but not serving query traffic. The data could be a potential master tablet.




#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;target tablet type&gt;</code> arguments are required for the <code>&lt;RunHealthCheck&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### ScrapTablet

Scraps a tablet.

#### Example

<pre class="command-example">ScrapTablet [-force] [-skip-rebuild] &lt;tablet alias&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| force | Boolean | Changes the tablet type to <code>scrap</code> in ZooKeeper or etcd if a tablet is offline |
| skip-rebuild | Boolean | Skips rebuilding the shard and keyspace graph after scrapping the tablet |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;ScrapTablet&gt;</code> command. This error occurs if the command is not called with exactly one argument.


### SetReadOnly

Sets the tablet as read-only.

#### Example

<pre class="command-example">SetReadOnly &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;SetReadOnly&gt;</code> command. This error occurs if the command is not called with exactly one argument.
* failed reading tablet %v: %v


### SetReadWrite

Sets the tablet as read-write.

#### Example

<pre class="command-example">SetReadWrite &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;SetReadWrite&gt;</code> command. This error occurs if the command is not called with exactly one argument.
* failed reading tablet %v: %v


### Sleep

Blocks the action queue on the specified tablet for the specified amount of time. This is typically used for testing.

#### Example

<pre class="command-example">Sleep &lt;tablet alias&gt; &lt;duration&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 
* <code>&lt;duration&gt;</code> &ndash; Required. The amount of time that the action queue should be blocked. The value is a string that contains a possibly signed sequence of decimal numbers, each with optional fraction and a unit suffix, such as "300ms" or "1h45m". See the definition of the Go language's <a href="http://golang.org/pkg/time/#ParseDuration">ParseDuration</a> function for more details. Note that, in practice, the value should be a positively signed value. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> and <code>&lt;duration&gt;</code> arguments are required for the <code>&lt;Sleep&gt;</code> command. This error occurs if the command is not called with exactly 2 arguments.


### StartSlave

Starts replication on the specified slave.

#### Example

<pre class="command-example">StartSlave &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* action <code>&lt;StartSlave&gt;</code> requires <code>&lt;tablet alias&gt;</code> This error occurs if the command is not called with exactly one argument.
* failed reading tablet %v: %v


### StopSlave

Stops replication on the specified slave.

#### Example

<pre class="command-example">StopSlave &lt;tablet alias&gt;</pre>

#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* action <code>&lt;StopSlave&gt;</code> requires <code>&lt;tablet alias&gt;</code> This error occurs if the command is not called with exactly one argument.
* failed reading tablet %v: %v


### UpdateTabletAddrs

Updates the IP address and port numbers of a tablet.

#### Example

<pre class="command-example">UpdateTabletAddrs [-hostname &lt;hostname&gt;] [-ip-addr &lt;ip addr&gt;] [-mysql-port &lt;mysql port&gt;] [-vt-port &lt;vt port&gt;] [-vts-port &lt;vts port&gt;] &lt;tablet alias&gt;</pre>

#### Flags

| Name | Type | Definition |
| :-------- | :--------- | :--------- |
| hostname | string | The fully qualified host name of the server on which the tablet is running. |
| ip-addr | string | IP address |
| mysql-port | Int | The mysql port for the mysql daemon |
| vt-port | Int | The main port for the vttablet process |
| vts-port | Int | The encrypted port for the vttablet process |


#### Arguments

* <code>&lt;tablet alias&gt;</code> &ndash; Required. A Tablet Alias uniquely identifies a vttablet. The argument value is in the format <code>&lt;cell name&gt;-&lt;uid&gt;</code>. 

#### Errors

* The <code>&lt;tablet alias&gt;</code> argument is required for the <code>&lt;UpdateTabletAddrs&gt;</code> command. This error occurs if the command is not called with exactly one argument.
* malformed address: %v


