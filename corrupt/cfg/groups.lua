local cfg = {}

cfg.groups = {

--
--    ░██████╗████████╗░█████╗░███████╗███████╗
--    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝
--    ╚█████╗░░░░██║░░░███████║█████╗░░█████╗░░
--    ░╚═══██╗░░░██║░░░██╔══██║██╔══╝░░██╔══╝░░
--    ██████╔╝░░░██║░░░██║░░██║██║░░░░░██║░░░░░
--    ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░     

    ["Founder"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.addcar",
        "admin.managecommunitypot",
        "admin.moneymenu",
        "group.add.vip",
        "group.add.founder",
        "group.add.operationsmanager",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.vip",
        "group.remove.founder",
        "group.remove.operationsmanager",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets",
        "cardev.menu",
        "vip.gunstore",
        "vip.garage",
        "police.dev"
    },
    ["Lead Developer"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.addcar",
        "admin.managecommunitypot",
        "admin.moneymenu",
        "group.add.vip",
        "group.add.founder",
        "group.add.operationsmanager",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.vip",
        "group.remove.founder",
        "group.remove.operationsmanager",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets",
        "cardev.menu",
        "vip.gunstore",
        "vip.garage",
        "police.dev"
    },
    ["Developer"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.addcar",
        "admin.managecommunitypot",
        "admin.moneymenu",
        "group.add.vip",
        "group.add.founder",
        "group.add.operationsmanager",
        "group.add.staffmanager",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.vip",
        "group.remove.founder",
        "group.remove.operationsmanager",
        "group.remove.staffmanager",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets",
        "cardev.menu",
        "vip.gunstore",
        "vip.garage",
        "police.dev"
    },
    ["Operations Manager"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.addcar",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "dev.menu",
        "admin.managecommunitypot",
        "admin.moneymenu",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets"
    },
    ["Staff Manager"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.addcar",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "cardev.menu",
        "group.add.vip",
        "group.add.commanager",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.vip",
        "group.remove.commanager",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets"
    },
    ["Community Manager"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.addcar",
        "admin.freeze",
        "admin.getgroups",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "dev.menu",
        "admin.managecommunitypot",
        "group.add.headadmin",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.headadmin",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets"
    },
    ["Head Administrator"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "group.add.senioradmin",
        "group.add.administrator",
        "group.add.srmoderator",
        "group.add.moderator",
        "group.add.supportteam",
        "group.add.trial",
        "group.add.pov",
        "group.add",
        "group.remove.senioradmin",
        "group.remove.administrator",
        "group.remove.srmoderator",
        "group.remove.moderator",
        "group.remove.supportteam",
        "group.remove.trial",
        "group.remove.pov",
        "group.remove",
        "admin.tickets"
    },
    ["Senior Administrator"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.removewarn",
        "admin.noclip",
        "admin.tickets"
    },
    ["Administrator"] = {
        "admin.ban",
        "admin.unban",
        "admin.kick",
        "admin.revive",
        "admin.tp2player",
        "admin.freeze",
        "admin.spectate",
        "admin.screenshot",
        "admin.video",
        "admin.slap",
        "admin.tp2waypoint",
        "admin.tp2coords",
        "admin.noclip",
        "admin.tickets"
    },
    ["Senior Moderator"] = {
        "admin.ban",
        "admin.kick",
        "admin.revive",
        "admin.slap",
        "admin.tp2player",
        "admin.freeze",
        "admin.screenshot",
        "admin.video",
        "admin.spectate",
        "admin.tickets",
    },
    ["Moderator"] = {
        "admin.ban",
        "admin.kick",
        "admin.tp2player",
        "admin.freeze",
        "admin.screenshot",
        "admin.video",
        "admin.spectate",
        "admin.tickets",
        "admin.revive",
    },
    ["Support Team"] = {
        "admin.kick",
        "admin.spectate",
        "admin.tp2player",
        "admin.freeze",
        "admin.tickets",
        "admin.screenshot",
        "admin.video",
    },
    ["Trial Staff"] = {
        "admin.kick",
        "admin.tp2player",
        "admin.freeze",
        "admin.tickets",
    },
    ["cardev"] = {
        "cardev.menu"
    },
   

--  ███╗░░░███╗███████╗████████╗  ██████╗░░█████╗░██╗░░░░░██╗░█████╗░███████╗
--  ████╗░████║██╔════╝╚══██╔══╝  ██╔══██╗██╔══██╗██║░░░░░██║██╔══██╗██╔════╝
--  ██╔████╔██║█████╗░░░░░██║░░░  ██████╔╝██║░░██║██║░░░░░██║██║░░╚═╝█████╗░░
--  ██║╚██╔╝██║██╔══╝░░░░░██║░░░  ██╔═══╝░██║░░██║██║░░░░░██║██║░░██╗██╔══╝░░
--  ██║░╚═╝░██║███████╗░░░██║░░░  ██║░░░░░╚█████╔╝███████╗██║╚█████╔╝███████╗
--  ╚═╝░░░░░╚═╝╚══════╝░░░╚═╝░░░  ╚═╝░░░░░░╚════╝░╚══════╝╚═╝░╚════╝░╚══════╝
                                                              
    ["Large Arms Access"] = {
        "police.loadshop2",
        "police.maxarmour"
    }, 
    ["Police Horse Trained"] = {}, 
    ["K9 Trained"] = {}, 
    ["Drone Trained"] = {},
    ["NPAS Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.npas",
        "police.onduty.permission",
    },
    ["NPAS"] = {
        "cop.whitelisted"
    },
    ["Trident Command Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.undercover",
        "police.tridentcommand",
        "police.onduty.permission",
    },
    ["Trident Command"] = {
        "cop.whitelisted"
    },
    ["Trident Officer Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.undercover",
        "police.tridentofficer",
        "police.onduty.permission",
    },
    ["Trident Officer"] = {
        "cop.whitelisted"
    },
    ["Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.commissioner",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["Commissioner"] = {
        "cop.whitelisted"
    },
    ["Deputy Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.deputycommissioner",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["Deputy Commissioner"] = {
        "cop.whitelisted"
    },
    ["Assistant Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.assistantcommissioner",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["Assistant Commissioner"] = {
        "cop.whitelisted"
    },
    ["Dep. Asst. Commissioner Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.deputyassistantcommissioner",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["Dep. Asst. Commissioner"] = {
        "cop.whitelisted"
    },
    ["GC Advisor Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.advisor",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["GC Advisor"] = {
        "cop.whitelisted"
    },
    ["Commander Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.commander",
        "police.maxarmour",
        "police.announce",
        "police.gc",
        "police.onduty.permission",
    },
    ["Commander"] = {
        "cop.whitelisted"
    },
    ["Chief Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.chiefsuperintendent",
        "police.maxarmour",
        "police.onduty.permission",
    },
    ["Chief Superintendent"] = {
        "cop.whitelisted"
    },
    ["Superintendent Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.superintendent",
        "police.maxarmour",
        "police.onduty.permission",
    },
    ["Superintendent"] = {
        "cop.whitelisted"
    },
    ["Special Constable Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.specialconstable",
        "police.announce",
        "police.maxarmour",
        "police.gc",
        "police.onduty.permission",
    },
    ["Special Constable"] = {
        "cop.whitelisted"
    },
    ["Chief Inspector Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.chiefinspector",
        "police.maxarmour",
        "police.onduty.permission",
    },
    ["Chief Inspector"] = {
        "cop.whitelisted"
    },
    ["Inspector Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.inspector",
        "police.onduty.permission",
    },
    ["Inspector"] = {
        "cop.whitelisted"
    },
    ["Sergeant Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.sergeant",
        "police.onduty.permission",
    },
    ["Sergeant"] = {
        "cop.whitelisted"
    },
    ["Senior Constable Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.seniorconstable",
        "police.onduty.permission",
    },
    ["Senior Constable"] = {
        "cop.whitelisted"
    },
    ["PC Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.constable",
        "police.onduty.permission",
    },
    ["PC"] = {
        "cop.whitelisted"
    },
    ["PCSO Clocked"] = {
        "cop.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.pcso",
        "police.onduty.permission",
    },
    ["PCSO"] = {
        "cop.whitelisted"
    },
    ["Police Raid"] = {
        "police.raid",
    },

    -- Border Force
    -- Border Force
    ["Director General Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.commissioner",
        "police.maxarmour",
        "police.announce"
    },
    ["Director General"] = {
        "border.whitelisted"
    },
    ["Regional Director Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.deputycommissioner",
        "police.maxarmour",
        "police.announce"
    },
    ["Regional Director Commissioner"] = {
        "border.whitelisted"
    },
    ["Assistant Director Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.assistantcommissioner",
        "police.maxarmour",
        "police.announce"
    },
    ["Assistant Director Commissioner"] = {
        "border.whitelisted"
    },
    ["Headquarters Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.deputyassistantcommissioner",
        "police.maxarmour",
        "police.announce"
    },
    ["Headquarters"] = {
        "border.whitelisted"
    },
    ["Advisor Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.announce",
        "police.advisor",
        "police.maxarmour",
        "police.announce"
    },
    ["Advisor"] = {
        "border.whitelisted"
    },
    ["Senior Immigration Officer Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.chiefsuperintendent",
        "police.maxarmour",
    },
    ["Senior Immigration Officer"] = {
        "border.whitelisted"
    },
    ["Higher Immigration Officer Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.superintendent",
        "police.maxarmour",
    },
    ["Higher Immigration Officer"] = {
        "border.whitelisted"
    },
    ["Immigration Officer Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.specialconstable",
        "police.announce",
        "police.maxarmour",
    },
    ["Immigration Officer"] = {
        "border.whitelisted"
    },
    ["Assistant Immigration Officer Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.chiefinspector",
        "police.maxarmour",
    },
    ["Assistant Immigration Officer"] = {
        "border.whitelisted"
    },
    ["Administrative Assistant Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.inspector",
    },
    ["Administrative Assistant"] = {
        "border.whitelisted"
    },
    ["Special Officer Clocked"] = {
        "border.whitelisted",
        "police.armoury",
        "police.armoury",
        "police.sergeant",
    },
    ["Special Officer"] = {
        "border.whitelisted"
    },


    -- HMP CBA TO MAKE A BIG THING LIKE THE OTHERS

      -- START HMP --



  ["Prison Officer"] = {
    "hmp.whitelisted",
	},

  ["Senior Officer"] = {
    "hmp.whitelisted",
	},

  ["Specialist Officer"] = {
    "hmp.whitelisted",
	},

  ["Principal Officer"] = {
    "hmp.whitelisted",
	},

  ["Supervising Officer"] = {
    "hmp.whitelisted",
	},

  ["Honourable Guard"] = {
    "hmp.whitelisted",
	},

  ["Custodial Officer"] = {
    "hmp.whitelisted",
	},

  ["Custodial Supervisor"] = {
    "hmp.whitelisted",
	},
  
  ["Divisional Commander"] = {
    "hmp.whitelisted",
	},
  ["Advisor"] = {
    "hmp.whitelisted",
	},
  ["Assistant Governor"] = {
    "hmp.whitelisted",
	},

  ["Deputy Governor"] = {
    "hmp.whitelisted",
	},

  ["Governor"] = {
    "hmp.whitelisted",

	},

  ["Trainee Prison Officer Clocked"] = {
		"hmp.traineeprisonofficer.whitelisted",
        "hmp.traineeprisonofficer",
        "hmp.menu",
	},

  ["Prison Officer Clocked"] = {
		"hmp.prisonofficer.whitelisted",
        "hmp.prisonofficer",
    "hmp.menu",
	},

  ["Senior Officer Clocked"] = {
		"hmp.seniorofficer.whitelisted",
        "hmp.seniorofficer",
    "hmp.menu",
	},

  ["Specialist Officer Clocked"] = {
		"hmp.specialistofficer.whitelisted",
        "hmp.specialistofficer",
    "hmp.menu",
	},

  ["Principal Officer Clocked"] = {
		"hmp.principalofficer.whitelisted",
        "hmp.principalofficer",
    "hmp.menu",
	},

  ["Supervising Officer Clocked"] = {
		"hmp.supervisingofficer.whitelisted",
        "hmp.supervisingofficer",
    "hmp.menu",
	},

  ["Honourable Guard Clocked"] = {
		"hmp.honourableguard.whitelisted",
        "hmp.honourableguard",
    "hmp.menu",
	},

  ["Custodial Officer Clocked"] = {
		"hmp.custodialofficer.whitelisted",
        "hmp.custodialofficer",
    "hmp.menu",
	},

  ["Custodial Supervisor Clocked"] = {
		"hmp.custodialsupervisor.whitelisted",
        "hmp.custodialsupervisor",
    "hmp.menu",
	},
  
  ["Divisional Commander Clocked"] = {
		"hmp.divisionalcommander.whitelisted",
        "hmp.divisionalcommander",
    "hmp.menu",
	},
  ["Advisor Clocked"] = {
		"hmp.advisorgovernor.whitelisted",
        "hmp.advisorgovernor",
    "hmp.menu",
	},
  ["Assistant Governor Clocked"] = {
		"hmp.assistantgovernor.whitelisted",
        "hmp.assistantgovernor",
    "hmp.menu",
	},
  ["Deputy Governor Clocked"] = {
		"hmp.deputygovernor.whitelisted",
        "hmp.deputygovernor",
    "hmp.menu",
	},

  ["Governor Clocked"] = {
		"hmp.governor.whitelisted",
        "hmp.governor",
    "hmp.menu",
	},

  -- END OF HMP --


--  ███╗░░██╗██╗░░██╗░██████╗
--  ████╗░██║██║░░██║██╔════╝
--  ██╔██╗██║███████║╚█████╗░
--  ██║╚████║██╔══██║░╚═══██╗
--  ██║░╚███║██║░░██║██████╔╝
--  ╚═╝░░╚══╝╚═╝░░╚═╝╚═════╝░

    ["HEMS Clocked"] = {
        "nhs.whitelisted",
        "nhs.menu",
        "nhs.hems",
    },
    ["HEMS"] = {
        "nhs.whitelisted"
    },                                               
    ["NHS Head Chief Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.headchief",
        "nhs.announce",
    },
    ["NHS Head Chief"] = {
        "nhs.whitelisted",
    },
    ["NHS Deputy Medical Director Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.assistantchief",
        "nhs.announce",
    },
    ["NHS Deputy Medical Director"] = {
        "nhs.whitelisted",
    },
    ["NHS Assistant Medical Director Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.deputychief",
        "nhs.announce",
    },
    ["NHS Assistant Medical Director"] = {
        "nhs.whitelisted",
    },
    ["NHS Specialist Surgeon Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.announce",
    },
    ["NHS Specialist Surgeon"] = {
        "nhs.whitelisted",
        "nhs.specialistsurgeon",
    },
    ["NHS Surgeon Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.surgeon",
    },
    ["NHS Surgeon"] = {
        "nhs.whitelisted",
    },
    ["NHS Specialist Doctor Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.specialistdoctor",
    },
    ["NHS Specialist Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Senior Doctor Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.seniordoctor",
    },
    ["NHS Senior Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Doctor Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.doctor",
    },
    ["NHS Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Junior Doctor Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.juniordoc",
    },
    ["NHS Junior Doctor"] = {
        "nhs.whitelisted",
    },
    ["NHS Critical Care Paramedic Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.criticalcareparamedic",
    },
    ["NHS Critical Care Paramedic"] = {
        "nhs.whitelisted",
    },
    ["NHS Paramedic Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.paramedic",
    },
    ["NHS Paramedic"] = {
        "nhs.whitelisted",
    },
    ["NHS Trainee Paramedic Clocked"] = {
        "nhs.menu",
        "nhs.whitelisted",
        "nhs.traineeparamedic",
    },
    ["NHS Trainee Paramedic"] = {
        "nhs.whitelisted",
    },

--  ██╗░░░░░██╗░█████╗░███████╗███╗░░██╗░██████╗███████╗░██████╗
--  ██║░░░░░██║██╔══██╗██╔════╝████╗░██║██╔════╝██╔════╝██╔════╝
--  ██║░░░░░██║██║░░╚═╝█████╗░░██╔██╗██║╚█████╗░█████╗░░╚█████╗░
--  ██║░░░░░██║██║░░██╗██╔══╝░░██║╚████║░╚═══██╗██╔══╝░░░╚═══██╗
--  ███████╗██║╚█████╔╝███████╗██║░╚███║██████╔╝███████╗██████╔╝
--  ╚══════╝╚═╝░╚════╝░╚══════╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═════╝░

    ["Weed"] = {},
    ["Cocaine"] = {},
    ["Meth"] = {},
    ["Heroin"] = {},
    ["LSD"] = {},
    ["Copper"] = {},
    ["Limestone"] = {},
    ["Gold"] = {},
    ["Diamond"] = {},
    ["Gang"] = {"gang.whitelisted"},
    ["Advanced Gang"] = {},
    ["Highroller"] = {
        "casino.highrollers"
    },
    ["Rebel"] = {
        "rebellicense.whitelisted"
    },
    ["AdvancedRebel"] = {
        "advancedrebel.license"
    },
    
--  ██████╗░░█████╗░███╗░░██╗░█████╗░████████╗░█████╗░██████╗░
--  ██╔══██╗██╔══██╗████╗░██║██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
--  ██║░░██║██║░░██║██╔██╗██║███████║░░░██║░░░██║░░██║██████╔╝
--  ██║░░██║██║░░██║██║╚████║██╔══██║░░░██║░░░██║░░██║██╔══██╗
--  ██████╔╝╚█████╔╝██║░╚███║██║░░██║░░░██║░░░╚█████╔╝██║░░██║
--  ╚═════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝
                                                                         
    ["Supporter"] = {
        "vip.gunstore",
        "vip.garage",
    },
    ["Premium"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Supreme"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Kingpin"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Rainmaker"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },
    ["Baller"] = {
        "vip.gunstore",
        "vip.garage",
        "vip.aircraft",
    },

--  ███╗░░░███╗██╗░██████╗░█████╗░███████╗██╗░░░░░██╗░░░░░░█████╗░███╗░░██╗███████╗░█████╗░██╗░░░██╗░██████╗
--  ████╗░████║██║██╔════╝██╔══██╗██╔════╝██║░░░░░██║░░░░░██╔══██╗████╗░██║██╔════╝██╔══██╗██║░░░██║██╔════╝
--  ██╔████╔██║██║╚█████╗░██║░░╚═╝█████╗░░██║░░░░░██║░░░░░███████║██╔██╗██║█████╗░░██║░░██║██║░░░██║╚█████╗░
--  ██║╚██╔╝██║██║░╚═══██╗██║░░██╗██╔══╝░░██║░░░░░██║░░░░░██╔══██║██║╚████║██╔══╝░░██║░░██║██║░░░██║░╚═══██╗
--  ██║░╚═╝░██║██║██████╔╝╚█████╔╝███████╗███████╗███████╗██║░░██║██║░╚███║███████╗╚█████╔╝╚██████╔╝██████╔╝
--  ╚═╝░░░░░╚═╝╚═╝╚═════╝░░╚════╝░╚══════╝╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝░╚════╝░░╚═════╝░╚═════╝░   

    ["pov"] = {
        "pov.list"
    },
    ["NewPlayer"] = {
        "pov.list"
    },
    ["DJ"] = {
        "dj.menu"
    },
    ["PilotLicense"] = {
        "air.whitelisted"
    },
    ["AA Mechanic"] = {
        "aa.menu"
    },
    ["Cinematic"] = {},
    ["TutorialDone"] = {},
    ["polblips"] = {},
    -- Default Jobs
    ["Royal Mail Driver"] = {},
    ["Bus Driver"] = {},
    ["Deliveroo"] = {},
    ["Scuba Diver"] = {},
    ["G4S Driver"] = {},
    ["Taco Seller"] = {},
}

return cfg
