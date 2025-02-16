const { EmbedBuilder, MessageActionRow, MessageButton } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');


module.exports = {
    name: "ban",
    description: "Ban a player from the server.",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "duration",
            description: "Ban Duration",
            type: 3,
            required: true,
            choices: [
                {
                    name: "1 Day",
                    value: "24"
                },
                {
                    name: "2 Days",
                    value: "48"
                },
                {
                    name: "7 Days",
                    value: "168"
                },
                {
                    name: "14 Days",
                    value: "336"
                },
                {
                    name: "30 Days",
                    value: "720"
                },
                {
                    name: "Permanent",
                    value: "-1"
                }
            ]
        },
        {
            name: "reason",
            description: "Ban Reason",
            type: 3,
            required: true,
        },
        {
            name: "evidence",
            description: "Ban Evidence",
            type: 3,
            required: true,
        }
    ],
    perm: 3,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
            
        let permid = interaction.options.getInteger('user_id')
        let duration = interaction.options.getString('duration')
        let reason = interaction.options.getString('reason')
        let evidence = interaction.options.getString('evidence')
        let adminname = interaction.user.username
        if (duration == "-1") {
            if (evidence) {
                let newval = fivemexports.corrupt.corruptbot('banDiscord', [permid, "perm", `${reason}`, `${adminname} via Discord.`, `${evidence}`])
            }
            else {
                let newval = fivemexports.corrupt.corruptbot('banDiscord', [permid, "perm", `${reason}`, `${adminname} via Discord.`, `No Evidence Provided`])
            }
        }
        else {
            if (evidence) {
                let newval = fivemexports.corrupt.corruptbot('banDiscord', [permid, duration, `${reason}`, `${adminname} via Discord.`, `${evidence}`])
            }
            else {
                let newval = fivemexports.corrupt.corruptbot('banDiscord', [permid, duration, `${reason}`, `${adminname} via Discord.`, `No Evidence Provided`])
            }
        }

        const embed = new EmbedBuilder()
        .setTitle("Banned Player")
        .setDescription(`\nPerm ID: **${permid}**\n\nDuration: **${duration}**\n\nReason: **${reason}**\n\nAdmin: **<@${interaction.user.id}>**`)
        .setColor(0x0078ff)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });

    },
};