const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "d2p",
    description: "Discord To Perm ID",
    options: [
        {
            name: "discord",
            description: "User's Discord Account",
            type: 6,
            required: true,
        },
    ],
    perm: 1,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
        let user = interaction.options.getUser('discord')
        fivemexports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE discord_id = ?", [user.id], (result) => {
            if (result.length > 0) {
                const embed = new EmbedBuilder()
                .setTitle("Discord To Perm ID")
                .setDescription(`User: **<@${user.id}>**\n\nPerm ID: **${result[0].user_id}**\n\n`)
                .setColor(0x0078FF)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            } else {
                interaction.reply({ content: `<@${user.id}> Is not linked to a perm id`, ephemeral: true });
            }
        });
    },
};