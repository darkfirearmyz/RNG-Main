cfg = {
	Guild_ID = '1340522588736061470',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1293223785318711418', 
		['Police'] = '1293223785318711418', 
		['NHS'] = '1293223785318711418',
		['HMP'] = '1293223785318711418',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
    ['Main'] = {
        ['Founder'] = 1340522589071736904, -- 12 1271575952304111756
        ['Lead Developer'] = 1340522589059026963, -- 11 1271575952304111755
        ['Developer'] = 1340522589059026962,
        ['Operations Manager'] = 1340522589059026964,
        ['Community Manager'] = 1340522589059026961, -- 9
        ['Staff Manager'] = 1340522589059026960, -- 8
        ['Head Administrator'] = 1340522589059026957, -- 7
        ['Senior Administrator'] = 1340522589059026956, -- 6
        ['Administrator'] = 1340522589042245692, -- 5
        ['Senior Moderator'] =1340522589042245691, -- 4
        ['Moderator'] = 1340522589042245690, -- 3 
        ['Support Team'] = 1340522589042245688, -- 2
        ['Trial Staff'] = 1340522589042245687, -- 1 1271575952291270785
        ['cardev'] = 1340522589042245685,
        ['Cinematic'] = 1340522588786397243,
    },

	['Police'] = {
        ['Commissioner'] = 1293663078684168292,
        ['Deputy Commissioner'] = 1293663079648854037,
        ['Assistant Commissioner'] = 1293663080617611346,
        ['Dep. Asst. Commissioner'] = 1293663081649537055,
        ['Commander'] = 1293663082706632877,
		['GC Advisor'] = 1293663084887675001,
        ['Chief Superintendent'] = 1293663094014349432,
        ['Superintendent'] = 1293663094979039304,
        ['Chief Inspector'] = 1293663100758655058,
        ['Inspector'] = 1293663101409038450,
        ['Sergeant'] = 1293663103598198975,
        ['Special Constable'] = 1293663116453875793,
		['PC'] = 1293663105418662008,
		['PCSO'] = 1293663114197336066,
		['Large Arms Access'] = 1293663235287023676,
		['Police Horse Trained'] = 1293663253683114086,
		['Drone Trained'] = 1271752491179966497,
		['NPAS'] = 1293663218568269874,
		['K9 Trained'] = 1293663255859953757,
		['Police Raid'] = 1293663151425978398,
	},

	['NHS'] = {
        ['NHS Head Chief'] = 1293666640105308270,
        ['NHS Deputy Medical Director'] = 1293666641007218818,
        ['NHS Assistant Medical Director'] = 1293666641997074533,
        ['NHS Specialist Surgeon'] = 1293676870335991838,
        ['NHS Surgeon'] = 1293676982151675924,
        ['NHS Senior Doctor'] = 1293666678290382898,
        ['NHS Doctor'] = 1293666679078916228,
        ['NHS Junior Doctor'] = 1275574777406427308,
        ['NHS Critical Care Paramedic'] = 1293666681872191518,
        ['NHS Paramedic'] = 1293666685357920298,
        ['NHS Trainee Paramedic'] = 1293666719306485790,
    },
	
	['HMP'] = {
        ['Governor'] = 1293669148731244637,
        ['Deputy Governor'] = 1293669150446850159,
		['Assistant Governor'] = 1269728821859324038,
		['Advisor'] = 1293669155089944728,
        ['Divisional Commander'] = 1266463323776618670,
        ['Custodial Supervisor'] = 1293669165743341570,
        ['Custodial Officer'] = 1293669166951436308,
        ['Honourable Guard'] = 1293669178322059356,
        ['Supervising Officer'] = 1293669174115045437,
        ['Principal Officer'] = 1293669173037236315, 
        ['Specialist Officer'] = 1266463323742801954, 
        ['Senior Officer'] = 1293669175419605163,
        ['Prison Officer'] = 1293669176463982705,
        ['Trainee Prison Officer'] = 1293669177491718174, 
	},
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTM0MDUyNDQzNDUyMzU1NzkyMA.GPF3_7.2ec6uUf4zItu6_6wpUZX-SlTXaUdtWv0D_-IU8'

return cfg