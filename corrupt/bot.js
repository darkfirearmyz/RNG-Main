const { Client, GatewayIntentBits, Partials, EmbedBuilder, ButtonBuilder,PermissionsBitField, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle, SelectMenuBuilder, InteractionType} = require("discord.js");
const fs = require("fs");
const settingsjson = require("./settings.js");
const statusLeaderboard = require("./statusleaderboard.json");
const { perm, guild, support } = require("./commands/garage.js");
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const client = new Client({
	partials: [
		Partials.Message, // for message
		Partials.Channel, // for text channel
		Partials.GuildMember, // for guild member
		Partials.Reaction, // for message reaction
		Partials.GuildScheduledEvent, // for guild events
		Partials.User, // for discord user
		Partials.ThreadMember, // for thread member
	],
	intents: [
		GatewayIntentBits.Guilds, // for guild related things
		GatewayIntentBits.GuildMembers, // for guild members related things
		GatewayIntentBits.GuildBans, // for manage guild bans
		GatewayIntentBits.GuildEmojisAndStickers, // for manage emojis and stickers
		GatewayIntentBits.GuildIntegrations, // for discord Integrations
		GatewayIntentBits.GuildWebhooks, // for discord webhooks
		GatewayIntentBits.GuildInvites, // for guild invite managing
		GatewayIntentBits.GuildVoiceStates, // for voice related things
		GatewayIntentBits.GuildPresences, // for user presence things
		GatewayIntentBits.GuildMessages, // for guild messages things
		GatewayIntentBits.GuildMessageReactions, // for message reactions things
		GatewayIntentBits.GuildMessageTyping, // for message typing things
		GatewayIntentBits.DirectMessages, // for dm messages
		GatewayIntentBits.DirectMessageReactions, // for dm message reaction
		GatewayIntentBits.DirectMessageTyping, // for dm message typing
		GatewayIntentBits.MessageContent, // enable if you need message content things
	],
});

module.exports = client;

client.getPerms = function(member) {
	let settings = settingsjson.settings
	let lvl1 = settings.Level1Perm;
	let lvl2 = settings.Level2Perm;
	let lvl3 = settings.Level3Perm;
	let lvl4 = settings.Level4Perm;
	let lvl5 = settings.Level5Perm;
	let lvl6 = settings.Level6Perm;
	let lvl7 = settings.Level7Perm;
	let lvl8 = settings.Level8Perm;
	let lvl9 = settings.Level9Perm;
	let lvl10 = settings.Level10Perm;
	let lvl11 = settings.Level11Perm;
	let level = 0 
	if (member._roles.includes(lvl11)) {
		level = 11
	} else if (member._roles.includes(lvl10)) {
		level = 10
	} else if (member._roles.includes(lvl9)) {
		level = 9
	} else if (member._roles.includes(lvl8)) {
		level = 8
	} else if (member._roles.includes(lvl7)) {
		level = 7
	} else if (member._roles.includes(lvl6)) {
		level = 6
	} else if (member._roles.includes(lvl5)) {
		level = 5
	} else if (member._roles.includes(lvl4)) {
		level = 4
	} else if (member._roles.includes(lvl3)) {
		level = 3
	} else if (member._roles.includes(lvl2)) {
		level = 2
	} else if (member._roles.includes(lvl1)) {
		level = 1
	}
	return level 
}

client.fivemexports = exports
fs.readdir(resourcePath + "/events", (_err, files) => {
	files.forEach((file) => {
		if (!file.endsWith(".js")) return;
		const event = require(`./events/${file}`);
		let eventName = file.split(".")[0];
		client.on(eventName, event.bind(null, client));
		delete require.cache[require.resolve(`./events/${file}`)];
	});
});

let onlinePD = 0;
let onlineStaff = 0;
let onlineNHS = 0;
let onlineHMP = 0;
let averagePing = 0;
let serverStatus = "";
let whitelist = false;
let memberCount = 0;
let currentFooterEmoji = '⚪';

setInterval(() => {
    if (currentFooterEmoji === "⚪") {
        currentFooterEmoji = "🔵";
    } else {
        currentFooterEmoji = "⚪";
    }
}, 300);

if (settingsjson.settings.StatusEnabled) {
    setInterval(() => {
        const channelid = client.channels.cache.get(settingsjson.settings.StatusChannel);
        if (!channelid) return console.log(`Status channel is not available / cannot be found.`);
        let guild = client.guilds.cache.get("1271575952115368008");
        memberCount = guild.memberCount;
        let settingsjsons = require(resourcePath + '/params.json');
        let totalSeconds = (client.uptime / 1000);
        totalSeconds %= 86400;
        let hours = Math.floor(totalSeconds / 3600);
        totalSeconds %= 3600;
        let minutes = Math.floor(totalSeconds / 60);
        exports.corrupt.getWhitelisted([], function (result) {
            whitelist = result;
        });
        client.user.setPresence({
            activities: [
                {
                    name: whitelist ? "Whitelist Enabled" : `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients", 64)} players`,
                    type: 3,
                },
            ],
            status: whitelist ? "dnd" : "online",
        });
        exports.corrupt.corruptbot('getUsersByPermission', ['police.armoury'], function (result) {
            onlinePD = result.length ? result.length : 0;
        });

        exports.corrupt.corruptbot('getUsersByPermission', ['hmp.menu'], function (result) {
            onlineHMP = result.length ? result.length : 0;
        });

        exports.corrupt.corruptbot('GetAveragePing', [''], function (result) {
            averagePing = result ? result : 0;
        });

        exports.corrupt.corruptbot('getUsersByPermission', ['admin.tickets'], function (result) {
            onlineStaff = result.length ? result.length : 0;
        });

        exports.corrupt.corruptbot('getUsersByPermission', ['nhs.menu'], function (result) {
            onlineNHS = result.length ? result.length : 0;
        });
        const embedcolour = settingsjson.settings.botColour;
        const statustext = ":white_check_mark: Online";
        let status = {};
        if (!whitelist) {
            status = {
                "color": embedcolour,
                "fields": [
                    {
                        "name": "Server Status",
                        "value": `${statustext}`,
                        "inline": true
                    },
                    {
                        "name": "Average Player Ping",
                        "value": `${averagePing}ms`,
                        "inline": true
                    },
                    {
                        "name": "Police",
                        "value": `${onlinePD}`,
                        "inline": true
                    },
                    {
                        "name": "NHS",
                        "value": `${onlineNHS}`,
                        "inline": true
                    },
                    {
                        "name": "HMP",
                        "value": `${onlineHMP}`,
                        "inline": true
                    },
                    {
                        "name": "Staff",
                        "value": `${onlineStaff}`,
                        "inline": true
                    },
                    {
                        "name": "Players",
                        "value": `${GetNumPlayerIndices()}/${GetConvarInt("sv_maxclients", 60)}`,
                        "inline": true
                    },
                    {
                        "name": "Members",
                        "value": `${memberCount}`,
                        "inline": true
                    },
                    {
                        "name": "",
                        "value": ``,
                        "inline": true
                    },
                    {
                        "name": "How do I direct connect?",
                        "value": '``F8 -> connect server.corruptstudios.co.uk``',
                        "inline": false
                    },
                    {
                        "name": "",
                        "value": ``,
                        "inline": true
                    }
                ],
                "author": {
                    "name": "Corrupt Server Status",
                    "icon_url": "https://cdn.discordapp.com/attachments/1129927706621005864/1198686465710903416/blue.png?ex=65bfcec3&is=65ad59c3&hm=d6e8eac661fd116a2c80e91946f3bca9cb3a8a7aaf3ae66908e42f6bc679d740&"
                },
                "footer": {
                    "text": `${currentFooterEmoji} Corrupt`
                },
                "timestamp": new Date()
            };
        } else {
            status = {
                "color": embedcolour,
                "fields": [
                    {
                        "name": "**The server is currently under development and is not available for public access.**",
                        "value": ``,
                        "inline": false
                    },
                    {
                        "name": "**This embed will update when the server is open again for the public.**",
                        "value": ``,
                        "inline": false
                    }
                ],
                "author": {
                    "name": "Corrupt Server Status",
                    "icon_url": "https://cdn.discordapp.com/attachments/1129927706621005864/1198686465710903416/blue.png?ex=65bfcec3&is=65ad59c3&hm=d6e8eac661fd116a2c80e91946f3bca9cb3a8a7aaf3ae66908e42f6bc679d740&"
                },
                "footer": {
                    "text": `${currentFooterEmoji} Corrupt`
                },
                "timestamp": new Date()
            };
        }
        const statusbutton = new ActionRowBuilder()
        .addComponents(
            new ButtonBuilder()
                .setLabel('Store')
                .setStyle(5)
                .setURL('https://corrupt.tebex.io')
        )
        .addComponents(
            new ButtonBuilder()
                .setLabel('Notified Role')
                .setStyle(2)
                .setCustomId('notifyrole')
        )
        .addComponents(
            new ButtonBuilder()
                .setLabel('Avarage FPS')
                .setStyle(2)
                .setCustomId('fps')
        );


        channelid.messages.fetch(settingsjsons.statusMessageID).then((msg) => {
            msg.edit({ embeds: [status], components: [statusbutton] });
        }).catch(err => {
            channelid.send({ embeds: [status], components: [statusbutton] }).then((msg) => {
                settingsjsons.statusMessageID = msg.id;
                fs.writeFileSync(resourcePath + '/params.json', JSON.stringify(settingsjsons));
            });
        });
    }, 8000);
}


function MathRandomised(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min);
}

client.commands = [];
fs.readdir(resourcePath + "/commands", (err, files) => {
	if (err) throw err;
	files.forEach(async (f) => {
		try {
			let props = require(`./commands/${f}`);
			client.commands.push({
				name: props.name,
				description: props.description,
				options: props.options,
                guild: props.guild,
                support: props.support
			});
		} catch (err) {
			console.log(err);
		}
	});
    if (!statusLeaderboard['leaderboard']) {
        statusLeaderboard['leaderboard'] = {}
      }
      else {
        statusLeaderboard['leaderboard'] = statusLeaderboard['leaderboard']
      }
});


client.on("messageCreate", async (message) => {
	if (message.author.bot) return;
    if (message.content.includes("discord.gg/")) {
        if (!message.member.permissions.has(PermissionsBitField.Flags.ManageMessages)) {
            message.delete();
        }
    }
    if (message.channel.id !== "1205921961415286894" || message.channel.id !== "1205921963600777216") {
        if (message.content.includes("http://") || message.content.includes("https://")) {
            if (!message.member.permissions.has(PermissionsBitField.Flags.ManageMessages)) {
                message.delete();
            }
        }
    }

	if (message.channel.name === "verify" || message.channel.name === "status") {
		message.delete();
	}


    if (message.content.startsWith("!")) {
        message.reply("The bot is no longer using the `!` prefix, please use `/` instead.").then((msg) => {
            setTimeout(() => {
                msg.delete();
            }, 5000);
        });
        return
    }
});

client.on("guildMemberAdd", function (member) {
    if (member.guild.id === "1271575952115368008") { // main guild auto assign roles if they are verified
        try {
            exports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE discord_id = ? AND verified = 1", [member.id], (result) => {
                if (result.length > 0) {
                    member.roles.add("1269355774954700886");
                }
                if (member.user.id === "1198043763356991569") {
                    member.roles.add("1205921751637426256");
                }
            });
        } catch (error) {
            console.error(error);
        }
    }
    if (member.guild.id === "1269734818371866687") { // logs discord auto assign roles if they are staff or management
        let guild = client.guilds.cache.get("1271575952115368008");
        let member1 = guild.members.cache.get(member.id);
        if (member1) {
            if (member1.roles.cache.has("1262462820201795655")) {
                member.roles.add("1198602370125410316");
            } else {
                member.kick();
            }
            if (member1.roles.cache.has("1264966043022135429")) {
                member.roles.add("1198602370125410317");
            }
            if (member1.roles.cache.has("1205921751637426256")) {
                member.roles.add("1198602370125410319");
            }
        }
    }
});


function daysBetween(dateString) {
    const d1 = new Date(dateString);
    const d2 = new Date();
    return Math.round((d2 - d1) / (1000 * 3600 * 24));
}

function VeryifyErrorEmbed(error) {
    const embed = new EmbedBuilder()
        .setTitle('Corrupt Verification')
        .setDescription(`:x: ${error}`)
        .setColor(0xFF0000)
        .setTimestamp();
    client.channels.cache.get('1271575960311038044').send({ embeds: [embed] });
}



client.on('interactionCreate', async interaction => {
    try {
        if (interaction.isButton()) {
            switch (interaction.customId) {
                case 'notifyrole':
                    if (interaction.member.roles.cache.has('1205921792577769612')) {
                        await interaction.member.roles.remove('1205921792577769612');
                        const removenotify = {
                            title: 'Notifications',
                            description: 'You will no longer receive notifications.',
                            color: 0x0078ff,
                        };
                        await interaction.reply({ embeds: [removenotify], ephemeral: true });
                    } else {
                        await interaction.member.roles.add('1271173946716323947');
                        const addnotify = {
                            title: 'Notifications',
                            description: 'You will now receive notifications.',
                            color: 0x0078ff,
                        };
                        await interaction.reply({ embeds: [addnotify], ephemeral: true });
                    }
                    break;
                case 'fps':
                    const fpstable = exports.corrupt.corruptbot('GetAverageFPS', ['']);
                    const allLocationsZero = Object.values(fpstable).every(value => value === 0);
                    const fpsEmbed = {
                        title: 'Average Frames per Second (FPS)',
                        description: 'This is the average FPS over the last 5 minutes.',
                        color: 0x0078ff,
                        fields: Object.entries(fpstable).map(([location, fps]) => ({
                            name: `**${location}**`,
                            value: fps !== 0 ? fps : 'No data available',
                            inline: true,
                        })),
                    };
                    await interaction.reply({ embeds: [fpsEmbed], ephemeral: true });
                    break;
                case 'verify':
                    const modal = new ModalBuilder()
                        .setCustomId('verification_code')
                        .setTitle('Corrupt Verification')
                        .addComponents([
                            new ActionRowBuilder().addComponents(
                                new TextInputBuilder()
                                    .setCustomId('verification-input-code')
                                    .setLabel('Verification Code')
                                    .setStyle(TextInputStyle.Short)
                                    .setMinLength(6)
                                    .setMaxLength(6)
                                    .setPlaceholder('A32B4C')
                                    .setRequired(true),
                            ),
                        ]);
                    await interaction.showModal(modal);
                    break;
                default:
                    break;
            }
        } else if (interaction.customId === 'verification_code') {
            const fivemexports = client.fivemexports;
            const code = interaction.fields.getTextInputValue('verification-input-code').toUpperCase();
            const accountAgeInDays = daysBetween(interaction.user.createdAt);
            if (accountAgeInDays < 1) {
                VeryifyErrorEmbed('<@' + interaction.user.id + '> tried to verify but the discord account is not 1 day old');
                const discordAccountageembed = new EmbedBuilder()
                    .setTitle('Corrupt Verification')
                    .setDescription(':x: Your Discord account must be at least 1 day old to use this command.')
                    .setColor(0xFF0000)
                    .setTimestamp();
                return await interaction.reply({ embeds: [discordAccountageembed], ephemeral: true });
            }
            const result = await new Promise((resolve, reject) => {
                fivemexports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE discord_id = ?", [interaction.user.id], (result) => {
                    resolve(result);
                });
            });
            if (result.length > 0 && result[0].discord_id === interaction.user.id) {
                VeryifyErrorEmbed('<@' + interaction.user.id + '> tried to verify but the discord was already linked to a Perm ID code is: ' + code);
                const alreadylinked = new EmbedBuilder()
                    .setTitle('Corrupt Verification')
                    .setDescription(':x: Your Discord account is already linked to a Perm ID.')
                    .setColor(0xFF0000)
                    .setTimestamp();
                return await interaction.reply({ embeds: [alreadylinked], ephemeral: true });
            } else {
                const resultcode = await new Promise((resolve, reject) => {
                    fivemexports.corrupt.execute(
                        "SELECT * FROM `corrupt_verification` WHERE code = ? AND verified = 0",
                        [code],
                        (resultcode) => {
                            resolve(resultcode);
                        }
                    );
                });
                if (resultcode.length > 0) {
                    if (resultcode[0].discord_id === null) {
                        await new Promise((resolve, reject) => {
                            fivemexports.corrupt.execute(
                                "UPDATE `corrupt_verification` SET discord_id = ?, verified = 1 WHERE code = ?",
                                [interaction.user.id, code],
                                async (result) => {
                                    if (result) {
                                        const SuccessEmbed = new EmbedBuilder()
                                            .setTitle('Corrupt Verification')
                                            .setDescription(':white_check_mark: Your Account has been verified you can now connect to the server!')
                                            .setColor(0x2ecc71)
                                            .setTimestamp();
                                        await interaction.reply({ embeds: [SuccessEmbed], ephemeral: true });
                                        await interaction.member.roles.add("1271575952115368011");
                                        const verifylog = new EmbedBuilder()
                                            .setTitle('Corrupt Verification Log')
                                            .setDescription(`**Perm ID**\n${resultcode[0].user_id}\n\n**Code**\n${code}\n\n**Discord**\n${interaction.user.username} - <@${interaction.user.id}>\n\n**Discord Created At**\n${interaction.user.createdAt}\n\n**Discord Account Age**\n${accountAgeInDays} Days`)
                                            .setColor(0x2ecc71)
                                            .setTimestamp();
                                        client.channels.cache.get("1271575960311038043").send({ embeds: [verifylog] });
                                        resolve();
                                    }
                                }
                            );
                        });
                    } else {
                        VeryifyErrorEmbed('<@' + interaction.user.id + '> tried to verify but discord_id in sql table is not null');
                        const alreadylinked = new EmbedBuilder()
                            .setTitle('Corrupt Verification')
                            .setDescription(':x: Unable to verify you please contact a staff member.')
                            .setColor(0xFF0000)
                            .setTimestamp();
                        return await interaction.reply({ embeds: [alreadylinked], ephemeral: true });
                    }
                } else {
                    VeryifyErrorEmbed('<@' + interaction.user.id + '> tried to verify with an invalid code code is: ' + code);
                    const invalidcode = new EmbedBuilder()
                        .setTitle('Corrupt Verification')
                        .setDescription(':x: The code you entered is invalid, please try again with a valid code.')
                        .setColor(0xFF0000)
                        .setTimestamp();
                    return await interaction.reply({ embeds: [invalidcode], ephemeral: true });
                }
            }
        }
    } catch (error) {
        console.error('An error occurred:', error);
        await interaction.reply({ content: ':x: An error occurred while processing your request.', ephemeral: true });
    }
});


client.setMaxListeners(15);


setInterval(function(){
    promotionDetection();
  }, 60*1000);
  
  function promotionDetection() {
    client.users.cache.forEach(user => { 
        if ((user.presence?.status === "online" || user.presence?.status === 'dnd' || user.presence?.status === 'idle') && !user.bot) { // check if user is online and is not a bot
            if (!statusLeaderboard['leaderboard'][user.id]) {
                var userProfile = {}; 
                statusLeaderboard['leaderboard'][user.id] = userProfile;
                statusLeaderboard['leaderboard'][user.id] = 0;
            }

            if (user.presence?.activities && user.presence.activities.length > 0 && typeof (user.presence.activities[0].state) === 'string' &&
                (user.presence.activities[0].state.includes('discord.gg/corrupt5m') || user.presence.activities[0].state.includes('.gg/corrupt5m'))) { // check if they have a status
                statusLeaderboard['leaderboard'][user.id] += 1;
                console.log(statusLeaderboard['leaderboard'][user.id]);
                fs.writeFileSync(`${resourcePath}/statusleaderboard.json`, JSON.stringify(statusLeaderboard));
            } else {
                delete statusLeaderboard['leaderboard'][user.id];
                fs.writeFileSync(`${resourcePath}/statusleaderboard.json`, JSON.stringify(statusLeaderboard));
            }
        }
    });
}

// functions for changing the colour of status embed on serevr restart or bot restart
const online = true;
function serverrestart(statment) {
    online = statment;
    console.log("Bot Is Chaning Status")
}

exports('serverrestart', (args) => {
    const statment = args[0];
    serverrestart(args[0]);
});



exports('dmUser', (source, args) => {
    let discord_id = args[0].trim();
    let code = args[1].toUpperCase();
    let user_id = args[2];

    const guild = client.guilds.cache.get('1271575952115368008');
    const member = guild.members.cache.get(discord_id);

    if (member) {
        const embed = new EmbedBuilder()
            .setTitle("Corrupt Studios")
            .setDescription(`User ID ${user_id} has requested to link this Discord account.\n\nThe code to link is **${code}**\nThis code will expire in 5 minutes.\n\nIf you have not requested this then you can safely ignore the message. Do **NOT** share this message or code with anyone else.`)
            .setColor(0x0078ff)
            .setThumbnail("https://cdn.discordapp.com/attachments/1129927706621005864/1198686465710903416/blue.png")
            .setTimestamp(new Date());
        member.send({ embeds: [embed] });
    }

    const logembed = new EmbedBuilder()
        .setTitle("Corrupt Request Reverify")
        .setDescription(`User ID ${user_id} has requested to link this Discord account.`)
        .setColor(0x0078ff)
        .setTimestamp(new Date());
    client.channels.cache.get('1291345623966289985')?.send({ embeds: [logembed] }); 
});



client.login(settingsjson.settings.token || process.env.TOKEN).catch(e => {
	console.log("The Bot Token You Entered Into Your Project Is Incorrect Or Your Bot's INTENTS Are OFF!");
});	



exports('dmUserText', (source, args) => {
    let discordid = args[0].trim()
    let message = args[1]
    let discord_guild = client.guilds.cache.get('1271575952115368008');
    let discord_member = discord_guild.members.cache.get(discordid);
    discord_member.send(message).catch(err => {
        fs.writeFile(`${client.path}/message_${discordid}.txt`, message, function(err) {
            discord_member.send(`Message is too large`, { files: [`${client.path}/message_${discordid}.txt`] }).then(ss => {
                fs.unlinkSync(`${client.path}/message_${discordid}.txt`)
            })
        });
    })
});