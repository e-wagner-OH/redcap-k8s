-- Set site perms back to site_admin as administrator
UPDATE redcap_config SET value = 'none' WHERE field_name = "auth_meth_global";