defmodule LiveSup.Test.Core.Datasources.DataHelper.JiraCurrentSprintIssues do
  def get() do
    """
    {
        "expand": "schema,names",
        "startAt": 0,
        "maxResults": 10,
        "total": 35,
        "issues": [
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "51564",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/51564",
                "key": "ENG-14669",
                "fields": {
                    "summary": "[API] Add bulk VLAN assign/unassign handlers to network_port and network_bond_port",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-04-16T11:45:42.640-0400",
                    "description": "We should add new methods to {{NetworkPort}} and {{NetworkBondPort}} which handle assigning and un-assigning multiple VLANs to/from the port in a single call.This could be tricky and/or just kind of tedious, as there’s a number of _additional_ things we do when assigning/un-assigning a VLAN to/from a port.Today, here’s the operations we do on our “individual” assignment/un-assignment calls, *in addition* to the actual {{add_vlan_to_iface}} call:When *assigning* a new VLAN:* For Network Bond Ports** If this is the first VLAN being assigned on the port, and the port is *NOT* in “hybrid bonded” mode, we send an {{enable_lag_vlan}} task to Narwhal *before* the actual assign vlan to iface call.** If there’s an internet gateway associated to the vlan, we send a {{create_internet_gateway}} task to narwhal *after* the assign vlan to iface call** For individual Network Ports** We send an {{ensure_vlan}} task to each switch to make sure the VLAN record exists on both switches the server is connected to, even if it’s not the switch this port is connected to.** We send a {{create_internet_gateway}} task to each switch the server is connected to, even if it’s not the switch this port is connected to.*When *un-assigning* a VLAN:* For Network Bond Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native vlan on the port.** If this was the last instance of this particular VLAN being used on the switch, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from the switch.** If this was the last instance of ANY VLAN assigned to this port, and the port was not in “hybrid bonded” mode, we send a {{disable_lag_Vlan}} task to narwhal.** We send a {{destroy_internet_gateway}} task to Narwhal if the VLAN is associated to an internet gateway** For Individual Network Ports** We un-set the native VLAN on the port if we’re removing the next-to-last VLAN remaining on the port, or if the VLAN being removed is set as the native VLAN on the port.** If this was the last instance of this particular VLAN being used on *either* switch in the switch pair, we also issue a {{delete_vnid}} task to narwhal to remove the vlan definition from both switches.** We send a {{destroy_internet_gateway}} task to Narwhal for both switches if this vlan was associated to an internet gateway and this was the last port associated to this vlan in the switch pair*So, as you can see, there’s quite a few edge/corner-cases we handle today for just assigning/un-assigning a single VLAN – and this will get even more complicated when assigning/un-assigning multiple VLAN at once, so it’s going to take some real work to make sure we get this right.*_NOTE REGARDING TASKS_* - We actually have a couple different tasks depending on the vlan “type”. For “old-style” facility-based vlans, tasks are named like {{ensure_vxlan}}, {{add_vlan_to_iface}}, etc. For “metro-based” vlans, or the “sprint-style” vlans, we have tasks like {{ensure_enhanced_vxlan}}, {{add_enhanced_vxlan_to_iface}}, etc.*_NOTE REGARDING INTERNET GATEWAYS_* - I don’t believe the internet gateway bits have been thoroughly tested, so my commentary here is just based on reading the code. It may change as the internet gateway epic moves towards completion this quarter.",
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "51563",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/51563",
                "key": "ENG-14668",
                "fields": {
                    "summary": "[API] Add bulk VLAN unassign endpoint",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-04-16T11:42:39.759-0400",
                    "description": "Add a new endpoint similar to our existing {{/ports/{id}/unassign}} endpoint but which accepts a list of VLAN UUID’s or VNI’s, and proceeds to perform a “bulk” unassign operation on the port/in narwhal. This endpoint should validate that each provided VLAN UUID or VNI exists, belongs to the project, and is in the same facility/metro as the port, and is already assigned to the port.",
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "52960",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/52960",
                "key": "ENG-15232",
                "fields": {
                    "summary": "[API] Refactor network_port VLAN assignment to support bulk ops",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-14T13:48:26.979-0400",
                    "description": null,
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "52962",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/52962",
                "key": "ENG-15233",
                "fields": {
                    "summary": "[API] Refactor network_bond_port VLAN assignment to support bulk ops",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-14T13:48:41.121-0400",
                    "description": null,
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "52963",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/52963",
                "key": "ENG-15234",
                "fields": {
                    "summary": "[API] Refactor network_port VLAN unassignment to support bulk ops",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-14T13:48:54.718-0400",
                    "description": null,
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "52964",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/52964",
                "key": "ENG-15235",
                "fields": {
                    "summary": "[API] Refactor network_bond_port VLAN unassignment to support bulk ops",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-14T13:49:11.678-0400",
                    "description": null,
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "54065",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/54065",
                "key": "ENG-15603",
                "fields": {
                    "summary": "[API] Validate a VLAN only appears once in the batch",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "created": "2021-06-07T10:12:00.059-0400",
                    "description": "In the case of a request with a body like:{noformat}{  port_id: the port uuid,  vlans: [    {id: 1234, state: assigned},    {id: 1234, state: unassigned}  ]}{noformat}We really don’t know what the user actually wants us to do, we should probably just make this request an error.Maybe the same even if both have the _same_ state, it’s probably easiest to just say “something’s not right here…”",
                    "assignee": null,
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "53187",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/53187",
                "key": "ENG-15331",
                "fields": {
                    "summary": "Fix top 10 slow tests in cucumber",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=557058%3Aaa898f62-ac74-4cd1-abf0-c4b352f6e9cd",
                        "accountId": "557058:aa898f62-ac74-4cd1-abf0-c4b352f6e9c2",
                        "emailAddress": "linda@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "24x24": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "16x16": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "32x32": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png"
                        },
                        "displayName": "Linda Cookie",
                        "active": true,
                        "timeZone": "America/New_York",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-18T15:10:45.175-0400",
                    "description": "(possibly rewrite them to rspec)Top 10 tests in cucumber all take over a minute to execute. Speeding them up will make it easier to divide the rest of the tests for parallel execution since we won't have big undivisible tasks anymore.My estimate for this is about 3-4 days.",
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5d6868ebe90c310c172268f3",
                        "accountId": "5d6868ebe90c310c172268f3",
                        "emailAddress": "crzysztof@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5d6868ebe90c310c172268f3/13a96b53-de49-418d-91af-66ab290795a3/48",
                            "24x24": "https://avatar.livesup.com/5d6868ebe90c310c172268f3/13a96b53-de49-418d-91af-66ab290795a3/24",
                            "16x16": "https://avatar.livesup.com/5d6868ebe90c310c172268f3/13a96b53-de49-418d-91af-66ab290795a3/16",
                            "32x32": "https://avatar.livesup.com/5d6868ebe90c310c172268f3/13a96b53-de49-418d-91af-66ab290795a3/32"
                        },
                        "displayName": "Chris Don",
                        "active": false,
                        "timeZone": "Europe/Warsaw",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10001",
                        "id": "10001",
                        "description": "This issue won't be actioned.",
                        "name": "Won't Do"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "53132",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/53132",
                "key": "ENG-15291",
                "fields": {
                    "summary": "Clean up old VLANs",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=557058%3Aaa898f62-ac74-4cd1-abf0-c4b352f6e9cd",
                        "accountId": "557058:aa898f62-ac74-4cd1-abf0-c4b352f6e9c2",
                        "emailAddress": "linda@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "24x24": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "16x16": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png",
                            "32x32": "https://livesup.com/avatar/a03203cc56ca00d2bd974980848f645b?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FLH-0.png"
                        },
                        "displayName": "Linda Cookie",
                        "active": true,
                        "timeZone": "America/New_York",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-18T10:28:37.798-0400",
                    "description": null,
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5c2fbd2a75b0e95216e90bb2",
                        "accountId": "5c2fbd2a75b0e95216e90bb2",
                        "emailAddress": "jordanmonday@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/48",
                            "24x24": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/24",
                            "16x16": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/16",
                            "32x32": "https://avatar.livesup.com/5c2fbd2a75b0e95216e90bb2/21dceb6f-7c7e-44b7-ab5c-231a8e8b057b/32"
                        },
                        "displayName": "Jordan Monday",
                        "active": true,
                        "timeZone": "America/Chicago",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            },
            {
                "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
                "id": "52677",
                "self": "https://livesup.atlassian.net/rest/agile/1.0/issue/52677",
                "key": "ENG-15132",
                "fields": {
                    "summary": "Swagger - fixing errors reported by Spectral linter ",
                    "creator": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5d3f522b0c3d830c304d322a",
                        "accountId": "5d3f522b0c3d830c304d322a",
                        "emailAddress": "muh@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/48",
                            "24x24": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/24",
                            "16x16": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/16",
                            "32x32": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/32"
                        },
                        "displayName": "Muhamed Rocky",
                        "active": false,
                        "timeZone": "America/New_York",
                        "accountType": "atlassian"
                    },
                    "created": "2021-05-10T06:35:28.787-0400",
                    "description": "Reported by [~accountid:5ed7f87d3a629c0a9bb39c9c] {noformat}$ spectral  lint livesup.fetched.json OpenAPI 2.0 (Swagger) detected/Users/marques/src/gometal/livesup.fetched.json  2392:13  warning  operation-operationId               Operation should have an `operationId`.             paths./incidents.get  2396:11  warning  operation-tag-defined               Operation tags should be defined in global tags.    paths./incidents.get.tags[0]  5709:14  warning  operation-operationId               Operation should have an `operationId`.             paths./hardware-reservations/{id}/move.post  5862:11  warning  operation-tag-defined               Operation tags should be defined in global tags.    paths./operating-system-versions.get.tags[0]  6332:11  warning  operation-tag-defined               Operation tags should be defined in global tags.    paths./reset-password.post.tags[0]  6366:11  warning  operation-tag-defined               Operation tags should be defined in global tags.    paths./reset-password.delete.tags[0]  7795:13  warning  operation-operationId               Operation should have an `operationId`.             paths./projects/{project_id}/self-service/reservations.get  7848:14  warning  operation-operationId               Operation should have an `operationId`.             paths./projects/{project_id}/self-service/reservations.post  7896:13  warning  operation-operationId               Operation should have an `operationId`.             paths./projects/{project_id}/self-service/reservations/{id}.get 11126:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.AuthToken.properties.user.description 11130:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.AuthToken.properties.project.description 11388:24  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.EntitlementInput 11414:23  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.EntitlementList 11460:18  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.EventInput 11489:21  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.EventTypeList 11535:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.Facility.properties.metro.description 11701:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.Device.properties.metro.description 11717:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.Device.properties.project.description 11721:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.Device.properties.project_lite.description 11819:22    error  oas2-valid-definition-example       `example` property should match format `uuid`       definitions.DeviceCreateInput.properties.hardware_reservation_id.example 11819:22    error  oas2-valid-parameter-example        `example` property should match format `uuid`       definitions.DeviceCreateInput.properties.hardware_reservation_id.example 11949:22  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.IpAddressInput 12061:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.Interconnection.properties.metro.description 12598:19    error  oas2-valid-response-schema-example  `example` property type should be number            definitions.BgpSessionNeighbors.properties.bgp_neighbors.items 12610:22    error  oas2-valid-definition-example       `example` property type should be number            definitions.BgpNeighborData.properties.address_family.example 12616:22    error  oas2-valid-definition-example       `example` property type should be number            definitions.BgpNeighborData.properties.customer_as.example 12639:22    error  oas2-valid-definition-example       `example` property type should be number            definitions.BgpNeighborData.properties.peer_as.example 12644:22    error  oas2-valid-definition-example       `example` property type should be array             definitions.BgpNeighborData.properties.peer_ips.example 12779:26  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.GlobalBgpRangeList 12840:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.IPAssignment.properties.metro.description 12914:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.IPReservation.properties.facility.description 12930:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.IPReservation.properties.metro.description 13418:19  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.PlanVersion 13499:16  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.PortList 13840:26    error  no-$ref-siblings                    $ref cannot be placed next to any other properties  definitions.SpotMarketRequest.properties.metro.description 14100:27  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.VolumeSnapshotInput 14308:30  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.SubscribableEventsList 14321:27  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.SupportRequestInput 14347:23    error  oas2-schema                         `required` property type should be array.           definitions.SupportRequestInput.properties.priority.required 14522:28  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.CapacityPerBaremetal 14825:16  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.Userdata 15036:23  warning  oas2-unused-definition              Potentially unused definition has been detected.    definitions.UserCreateInput{noformat}",
                    "assignee": {
                        "self": "https://livesup.atlassian.net/rest/api/2/user?accountId=5d3f522b0c3d830c304d322a",
                        "accountId": "5d3f522b0c3d830c304d322a",
                        "emailAddress": "muh@livesup.com",
                        "avatarUrls": {
                            "48x48": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/48",
                            "24x24": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/24",
                            "16x16": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/16",
                            "32x32": "https://avatar.livesup.com/5d3f522b0c3d830c304d322a/ca2243d8-b75e-44f3-955c-f7e30eebfe68/32"
                        },
                        "displayName": "Muhamed Rocky",
                        "active": false,
                        "timeZone": "America/New_York",
                        "accountType": "atlassian"
                    },
                    "resolution": {
                        "self": "https://livesup.atlassian.net/rest/api/2/resolution/10115",
                        "id": "10115",
                        "description": "Work has been completed on this issue and Acceptance Criteria has been met.",
                        "name": "Done"
                    },
                    "status": {
                        "self": "https://livesup.atlassian.net/rest/api/2/status/6",
                        "description": "Feature/product is deployed and part of Sales",
                        "iconUrl": "https://livesup.atlassian.net/images/icons/statuses/closed.png",
                        "name": "Complete",
                        "id": "6",
                        "statusCategory": {
                            "self": "https://livesup.atlassian.net/rest/api/2/statuscategory/3",
                            "id": 3,
                            "key": "done",
                            "colorName": "green",
                            "name": "Done"
                        }
                    }
                }
            }
        ]
    }
    """
  end
end
