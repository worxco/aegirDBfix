-- Aegir fix

-- Drop any temp tables left over from previous run
drop table if exists aegir_fix1;
drop table if exists aegir_fix2;

-- Create temp tables needed for this process
create temporary table if not exists aegir_fix1 (nid INT);
create temporary table if not exists aegir_fix2 (nid INT);

-- Provide the list of NID's that you want to clear out
insert into aegir_fix1 values(979);
-- insert into aegir_fix1 values(611);
-- insert into aegir_fix1 values(965);
-- insert into aegir_fix1 values(949);
-- OR -- if you like all the screwups on one line... --
-- insert into aegir_fix1 values(979), (611), (965), (etc...);

-- Get everything into the fix2 table.
insert into aegir_fix2 select nid from aegir_fix1;
insert into aegir_fix2 select nid from hosting_task where rid in (select nid from aegir_fix1);

-- Run the Deletions and clean up the tables;
delete from hosting_site where nid in (select nid from aegir_fix2 order by nid);
delete from hosting_site_alias where nid in (select nid from aegir_fix2 order by nid);
delete from history where nid in (select nid from aegir_fix2 order by nid);
delete from node where nid in (select nid from aegir_fix2 order by nid);
delete from node_access where nid in (select nid from aegir_fix2 order by nid);
delete from node_revisions where nid in (select nid from aegir_fix2 order by nid);
delete from hosting_task where rid in (select nid from aegir_fix2 order by nid);
delete from hosting_context where nid in (select nid from aegir_fix2 order by nid);
delete from hosting_ip_addresses where nid in (select nid from aegir_fix2 order by nid);
delete from hosting_package_instance where rid in (select nid from aegir_fix2 order by nid);
delete from hosting_ssl_site where nid in (select nid from aegir_fix2 order by nid);
delete from url_alias where src in (select concat('node/',nid) from aegir_fix2 order by nid);

-- Clear caches
truncate table cache;
truncate table cache_block;
truncate table cache_filter;
truncate table cache_form;
truncate table cache_menu;
truncate table cache_page;

-- Drop all temp tables now that we are done.
drop table if exists aegir_fix1;
drop table if exists aegir_fix2;
